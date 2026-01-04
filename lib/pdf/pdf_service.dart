import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';

import '../data/finalized_document_models.dart';
import '../data/finalized_documents_repo_local_first.dart';
import '../data/org_settings_repo_local_first.dart';
import '../data/pricing_profile_catalog_repo_local_first.dart';
import '../data/pricing_profile_models.dart';
import '../data/pricing_profiles_repo_local_first.dart';
import '../data/quote_models.dart';

class PdfService {
  PdfService({
    required FinalizedDocumentsRepositoryLocalFirst finalizedDocsRepository,
    required PricingProfilesRepositoryLocalFirst pricingProfilesRepository,
    required PricingProfileCatalogRepositoryLocalFirst
        pricingProfileCatalogRepository,
    required OrgSettingsRepositoryLocalFirst orgSettingsRepository,
    Uuid? uuid,
  })  : _finalizedDocsRepository = finalizedDocsRepository,
        _pricingProfilesRepository = pricingProfilesRepository,
        _pricingProfileCatalogRepository = pricingProfileCatalogRepository,
        _orgSettingsRepository = orgSettingsRepository,
        _uuid = uuid ?? const Uuid();

  final FinalizedDocumentsRepositoryLocalFirst _finalizedDocsRepository;
  final PricingProfilesRepositoryLocalFirst _pricingProfilesRepository;
  final PricingProfileCatalogRepositoryLocalFirst
      _pricingProfileCatalogRepository;
  final OrgSettingsRepositoryLocalFirst _orgSettingsRepository;
  final Uuid _uuid;

  Future<FinalizedDocument> generateFinalizedDocument({
    required Quote quote,
    required FinalizedDocumentType docType,
    required String orgId,
  }) async {
    final quoteSnapshot = _finalizedDocsRepository.buildQuoteSnapshot(quote);
    final pricingSnapshot =
        await buildPricingSnapshot(quote.pricingProfileId);
    final totals = calculateTotals(
      quoteSnapshot: quoteSnapshot,
      pricingSnapshot: pricingSnapshot,
    );
    final totalsSnapshot = _finalizedDocsRepository.buildTotalsSnapshot(
      minutes: totals.minutes,
      hours: totals.hours,
      subtotal: totals.subtotal,
      tax: totals.tax,
      ccFee: totals.ccFee,
      total: totals.total,
    );
    final createdAt = DateTime.now();
    final documentNumber =
        _documentNumber(docType: docType, createdAt: createdAt);
    final docId = _uuid.v4();
    final pdfBytes = await _buildPdf(
      docType: docType,
      quoteSnapshot: quoteSnapshot,
      pricingSnapshot: pricingSnapshot,
      totalsSnapshot: totalsSnapshot,
      createdAt: createdAt,
      documentNumber: documentNumber,
    );
    final localPath = await _savePdf(
      orgId: orgId,
      quoteId: quote.id,
      docId: docId,
      bytes: pdfBytes,
    );
    return _finalizedDocsRepository.createFinalizedDoc(
      id: docId,
      quoteId: quote.id,
      docType: docType.value,
      status: 'generated',
      localPath: localPath,
      quoteSnapshot: quoteSnapshot,
      pricingSnapshot: pricingSnapshot,
      totalsSnapshot: totalsSnapshot,
    );
  }

  Future<Map<String, dynamic>> buildPricingSnapshot(String profileId) async {
    final trimmed = profileId.trim();
    final orgSettings = await _orgSettingsRepository.getCurrent();
    final resolvedProfileId = trimmed.isEmpty
        ? orgSettings.defaultPricingProfileId
        : trimmed;
    if (resolvedProfileId == 'default') {
      await _pricingProfilesRepository.ensureDefaultCatalogSeeded();
    }
    final header = await _pricingProfilesRepository.getProfileById(
      resolvedProfileId,
    );
    final catalog =
        await _pricingProfileCatalogRepository.loadCatalog(resolvedProfileId);
    return {
      'profile': _mapPricingHeader(
        header,
        fallback: orgSettings,
        profileId: resolvedProfileId,
      ),
      'serviceTypes': catalog.serviceTypes.map(_mapServiceType).toList(),
      'frequencies': catalog.frequencies.map(_mapFrequency).toList(),
      'roomTypes': catalog.roomTypes.map(_mapRoomType).toList(),
      'subItems': catalog.subItems.map(_mapSubItem).toList(),
      'sizes': catalog.sizes.map(_mapSize).toList(),
      'complexities': catalog.complexities.map(_mapComplexity).toList(),
    };
  }

  TotalsSnapshot calculateTotals({
    required Map<String, dynamic> quoteSnapshot,
    required Map<String, dynamic> pricingSnapshot,
  }) {
    final items = quoteSnapshot['items'] is List
        ? (quoteSnapshot['items'] as List)
            .whereType<Map<String, dynamic>>()
            .toList()
        : const <Map<String, dynamic>>[];
    final totalMinutes = items.fold<double>(0, (total, item) {
      final include = item['include'] == true;
      final qty = (item['qty'] as num?)?.toDouble() ?? 1;
      final minutes = (item['minutes'] as num?)?.toDouble() ?? 0;
      return total + (include ? minutes * qty : 0);
    });
    final serviceType = quoteSnapshot['serviceType']?.toString() ?? '';
    final frequency = quoteSnapshot['frequency']?.toString() ?? '';
    final serviceTypeMultiplier = _serviceTypeMultiplier(
      serviceType,
      pricingSnapshot,
    );
    final frequencyMultiplier = _frequencyMultiplier(
      serviceType,
      frequency,
      pricingSnapshot,
    );
    final adjustedMinutes =
        totalMinutes * serviceTypeMultiplier * frequencyMultiplier;
    final hours = adjustedMinutes / 60.0;
    final laborRate =
        (quoteSnapshot['laborRate'] as num?)?.toDouble() ?? 0.0;
    final taxEnabled = quoteSnapshot['taxEnabled'] == true;
    final taxRate = (quoteSnapshot['taxRate'] as num?)?.toDouble() ?? 0.0;
    final ccEnabled = quoteSnapshot['ccEnabled'] == true;
    final ccRate = (quoteSnapshot['ccRate'] as num?)?.toDouble() ?? 0.0;
    final subtotal = hours * laborRate;
    final tax = taxEnabled ? subtotal * taxRate : 0.0;
    final ccFee = ccEnabled ? (subtotal + tax) * ccRate : 0.0;
    final total = subtotal + tax + ccFee;
    return TotalsSnapshot(
      minutes: adjustedMinutes,
      hours: hours,
      subtotal: subtotal,
      tax: tax,
      ccFee: ccFee,
      total: total,
    );
  }

  Map<String, dynamic> _mapPricingHeader(
    PricingProfileHeader? header, {
    required dynamic fallback,
    required String profileId,
  }) {
    final base = header ?? PricingProfileHeader(
      id: profileId,
      orgId: '',
      name: 'Default',
      laborRate: fallback.laborRate,
      taxEnabled: fallback.taxEnabled,
      taxRate: fallback.taxRate,
      ccEnabled: fallback.ccEnabled,
      ccRate: fallback.ccRate,
      updatedAt: 0,
      deleted: false,
    );
    return {
      'id': base.id,
      'name': base.name,
      'laborRate': base.laborRate,
      'taxEnabled': base.taxEnabled,
      'taxRate': base.taxRate,
      'ccEnabled': base.ccEnabled,
      'ccRate': base.ccRate,
    };
  }

  Map<String, dynamic> _mapServiceType(PricingProfileServiceType row) => {
        'serviceType': row.serviceType,
        'description': row.description,
        'pricePerSqFt': row.pricePerSqFt,
        'multiplier': row.multiplier,
      };

  Map<String, dynamic> _mapFrequency(PricingProfileFrequency row) => {
        'serviceType': row.serviceType,
        'frequency': row.frequency,
        'multiplier': row.multiplier,
      };

  Map<String, dynamic> _mapRoomType(PricingProfileRoomType row) => {
        'roomType': row.roomType,
        'description': row.description,
        'minutes': row.minutes,
        'squareFeet': row.squareFeet,
      };

  Map<String, dynamic> _mapSubItem(PricingProfileSubItem row) => {
        'subItem': row.subItem,
        'description': row.description,
        'minutes': row.minutes,
      };

  Map<String, dynamic> _mapSize(PricingProfileSize row) => {
        'size': row.size,
        'multiplier': row.multiplier,
        'definition': row.definition,
      };

  Map<String, dynamic> _mapComplexity(PricingProfileComplexity row) => {
        'level': row.level,
        'multiplier': row.multiplier,
        'definition': row.definition,
      };

  double _serviceTypeMultiplier(
    String serviceType,
    Map<String, dynamic> pricingSnapshot,
  ) {
    final serviceTypes = pricingSnapshot['serviceTypes'] is List
        ? pricingSnapshot['serviceTypes'] as List
        : const [];
    for (final entry in serviceTypes) {
      if (entry is Map && entry['serviceType'] == serviceType) {
        return (entry['multiplier'] as num?)?.toDouble() ?? 1.0;
      }
    }
    return 1.0;
  }

  double _frequencyMultiplier(
    String serviceType,
    String frequency,
    Map<String, dynamic> pricingSnapshot,
  ) {
    final frequencies = pricingSnapshot['frequencies'] is List
        ? pricingSnapshot['frequencies'] as List
        : const [];
    for (final entry in frequencies) {
      if (entry is Map &&
          entry['serviceType'] == serviceType &&
          entry['frequency'] == frequency) {
        return (entry['multiplier'] as num?)?.toDouble() ?? 1.0;
      }
    }
    final baseType = _baseServiceType(serviceType);
    if (baseType != serviceType) {
      for (final entry in frequencies) {
        if (entry is Map &&
            entry['serviceType'] == baseType &&
            entry['frequency'] == frequency) {
          return (entry['multiplier'] as num?)?.toDouble() ?? 1.0;
        }
      }
    }
    return 1.0;
  }

  String _baseServiceType(String value) {
    if (value.contains('Standard Clean')) {
      return 'Standard Clean';
    }
    if (value.contains('Deep Clean')) {
      return 'Deep Clean';
    }
    return value;
  }

  String _documentNumber({
    required FinalizedDocumentType docType,
    required DateTime createdAt,
  }) {
    final yyyy = createdAt.year.toString();
    final mm = createdAt.month.toString().padLeft(2, '0');
    final dd = createdAt.day.toString().padLeft(2, '0');
    final suffix = _uuid.v4().split('-').first.toUpperCase();
    final prefix = docType == FinalizedDocumentType.invoice ? 'INV' : 'QTE';
    return '$prefix-$yyyy$mm$dd-$suffix';
  }

  Future<Uint8List> _buildPdf({
    required FinalizedDocumentType docType,
    required Map<String, dynamic> quoteSnapshot,
    required Map<String, dynamic> pricingSnapshot,
    required Map<String, dynamic> totalsSnapshot,
    required DateTime createdAt,
    required String documentNumber,
  }) async {
    final pdf = pw.Document();
    final title = docType == FinalizedDocumentType.invoice
        ? 'Invoice'
        : 'Quote / Estimate';
    final clientName = quoteSnapshot['clientName']?.toString() ?? '';
    final address = quoteSnapshot['address']?.toString() ?? '';
    final items = quoteSnapshot['items'] is List
        ? (quoteSnapshot['items'] as List)
            .whereType<Map<String, dynamic>>()
            .toList()
        : const <Map<String, dynamic>>[];
    final subtotal = (totalsSnapshot['subtotal'] as num?)?.toDouble() ?? 0.0;
    final tax = (totalsSnapshot['tax'] as num?)?.toDouble() ?? 0.0;
    final ccFee = (totalsSnapshot['ccFee'] as num?)?.toDouble() ?? 0.0;
    final total = (totalsSnapshot['total'] as num?)?.toDouble() ?? 0.0;
    final hours = (totalsSnapshot['hours'] as num?)?.toDouble() ?? 0.0;
    final profileName =
        pricingSnapshot['profile']?['name']?.toString() ?? 'Pricing Profile';
    final businessName = 'QuickQuote';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    businessName,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(profileName),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(title, style: pw.TextStyle(fontSize: 18)),
                  pw.Text('Document #: $documentNumber'),
                  pw.Text('Date: ${_formatDate(createdAt)}'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Divider(),
          pw.Text('Client', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(clientName),
          if (address.trim().isNotEmpty) pw.Text(address),
          pw.SizedBox(height: 12),
          if (docType == FinalizedDocumentType.invoice)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Invoice Details',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Due Date: ____________'),
                pw.Text('Payment Instructions: __________________________'),
                pw.SizedBox(height: 12),
              ],
            )
          else
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Quote Details',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Quote Expiry: ____________'),
                pw.SizedBox(height: 12),
              ],
            ),
          pw.Text('Line Items',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          _itemsTable(items),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Estimated Labor: ${hours.toStringAsFixed(2)} hrs'),
                  if (quoteSnapshot['specialNotes'] != null &&
                      quoteSnapshot['specialNotes']
                          .toString()
                          .trim()
                          .isNotEmpty)
                    pw.Text(
                      'Notes: ${quoteSnapshot['specialNotes']}',
                    ),
                ],
              ),
              pw.Container(
                width: 200,
                child: pw.Column(
                  children: [
                    _summaryRow('Subtotal', subtotal),
                    _summaryRow('Tax', tax),
                    _summaryRow('CC Fee', ccFee),
                    pw.Divider(),
                    _summaryRow('Total', total, bold: true),
                    if (docType == FinalizedDocumentType.invoice)
                      _summaryRow('Amount Due', total, bold: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _itemsTable(List<Map<String, dynamic>> items) {
    final headers = ['Item', 'Qty', 'Minutes', 'Notes'];
    final data = items.map((item) {
      final title = item['title']?.toString() ?? '';
      final qty = (item['qty'] as num?)?.toString() ?? '1';
      final minutes = (item['minutes'] as num?)?.toString() ?? '0';
      final notes = item['notes']?.toString() ?? '';
      return [title, qty, minutes, notes];
    }).toList();
    if (data.isEmpty) {
      data.add(['No line items recorded.', '', '', '']);
    }
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 24,
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(3),
      },
    );
  }

  pw.Widget _summaryRow(String label, double value, {bool bold = false}) {
    final style = bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null;
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Text(_money(value), style: style),
        ],
      ),
    );
  }

  Future<String> _savePdf({
    required String orgId,
    required String quoteId,
    required String docId,
    required Uint8List bytes,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final targetDir = Directory(
      p.join(dir.path, 'finalized', orgId, quoteId),
    );
    if (!targetDir.existsSync()) {
      await targetDir.create(recursive: true);
    }
    final file = File(p.join(targetDir.path, '$docId.pdf'));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  String _formatDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$mm/$dd/$yyyy';
  }

  String _money(double value) => '\$${value.toStringAsFixed(2)}';
}

class TotalsSnapshot {
  TotalsSnapshot({
    required this.minutes,
    required this.hours,
    required this.subtotal,
    required this.tax,
    required this.ccFee,
    required this.total,
  });

  final double minutes;
  final double hours;
  final double subtotal;
  final double tax;
  final double ccFee;
  final double total;
}

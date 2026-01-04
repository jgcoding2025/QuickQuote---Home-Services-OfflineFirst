import 'dart:convert';

enum FinalizedDocumentType {
  quote,
  invoice,
}

extension FinalizedDocumentTypeX on FinalizedDocumentType {
  String get value => this == FinalizedDocumentType.quote ? 'quote' : 'invoice';

  static FinalizedDocumentType? fromString(String value) {
    switch (value) {
      case 'quote':
        return FinalizedDocumentType.quote;
      case 'invoice':
        return FinalizedDocumentType.invoice;
    }
    return null;
  }
}

class FinalizedDocument {
  FinalizedDocument({
    required this.id,
    required this.orgId,
    required this.quoteId,
    required this.docType,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.localPath,
    required this.remotePath,
    required this.quoteSnapshot,
    required this.pricingSnapshot,
    required this.totalsSnapshot,
  });

  final String id;
  final String orgId;
  final String quoteId;
  final String docType;
  final int createdAt;
  final int updatedAt;
  final String status;
  final String localPath;
  final String? remotePath;
  final Map<String, dynamic> quoteSnapshot;
  final Map<String, dynamic> pricingSnapshot;
  final Map<String, dynamic> totalsSnapshot;

  String get title => docType == 'invoice' ? 'Invoice' : 'Quote / Estimate';

  static Map<String, dynamic> decodeSnapshot(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return const <String, dynamic>{};
  }
}

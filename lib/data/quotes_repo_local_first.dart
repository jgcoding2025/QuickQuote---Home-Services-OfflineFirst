import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'local_db.dart';
import 'quote_models.dart';
import 'session_controller.dart';
import 'sync_service.dart';

class QuotesRepositoryLocalFirst {
  QuotesRepositoryLocalFirst({
    required AppDatabase db,
    required SessionController sessionController,
    required SyncService syncService,
    Uuid? uuid,
  })  : _db = db,
        _sessionController = sessionController,
        _syncService = syncService,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final SessionController _sessionController;
  final SyncService _syncService;
  final Uuid _uuid;

  String newQuoteId() => _uuid.v4();

  Stream<List<Quote>> streamQuotes() async* {
    final controller = StreamController<List<Quote>>();
    StreamSubscription<List<Quote>>? dataSub;

    Future<void> listenSession(AppSession? session) async {
      await dataSub?.cancel();
      if (session == null || session.orgId == null) {
        controller.add(const []);
        return;
      }
      dataSub = _db
          .watchQuotes(session.orgId!)
          .asyncMap(_mapQuotes)
          .listen(
            controller.add,
            onError: controller.addError,
          );
    }

    await listenSession(_sessionController.value);
    final sessionSub = _sessionController.stream.listen(listenSession);
    controller.onCancel = () async {
      await dataSub?.cancel();
      await sessionSub.cancel();
    };

    yield* controller.stream;
  }

  Stream<List<Quote>> streamQuotesForClient(String clientId) async* {
    final controller = StreamController<List<Quote>>();
    StreamSubscription<List<Quote>>? dataSub;

    Future<void> listenSession(AppSession? session) async {
      await dataSub?.cancel();
      if (session == null || session.orgId == null) {
        controller.add(const []);
        return;
      }
      dataSub = _db
          .watchQuotesForClient(session.orgId!, clientId)
          .asyncMap(_mapQuotes)
          .listen(
            controller.add,
            onError: controller.addError,
          );
    }

    await listenSession(_sessionController.value);
    final sessionSub = _sessionController.stream.listen(listenSession);
    controller.onCancel = () async {
      await dataSub?.cancel();
      await sessionSub.cancel();
    };

    yield* controller.stream;
  }

  Stream<Quote?> watchQuoteById(String quoteId) async* {
    final controller = StreamController<Quote?>();
    StreamSubscription<Quote?>? dataSub;

    Future<void> listenSession(AppSession? session) async {
      await dataSub?.cancel();
      if (session == null || session.orgId == null) {
        controller.add(null);
        return;
      }
      dataSub = _db
          .watchQuoteById(session.orgId!, quoteId)
          .asyncMap(_mapQuoteRowOrNull)
          .listen(
            controller.add,
            onError: controller.addError,
          );
    }

    await listenSession(_sessionController.value);
    final sessionSub = _sessionController.stream.listen(listenSession);
    controller.onCancel = () async {
      await dataSub?.cancel();
      await sessionSub.cancel();
    };

    yield* controller.stream;
  }

  Future<void> setQuote(
    String quoteId,
    QuoteDraft d, {
    required bool isNew,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertQuote(_quoteCompanion(quoteId, orgId, d, now));
    await _replaceItems(quoteId, orgId, d.items, now);
    await _insertOutbox(
      entityType: 'quote',
      entityId: quoteId,
      opType: isNew ? 'create' : 'update',
      payload: {
        ...d.toMap(),
        'updatedAt': now,
        'deleted': false,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  Future<Quote> createQuote(QuoteDraft d) async {
    final id = newQuoteId();
    await setQuote(id, d, isNew: true);
    return Quote(
      id: id,
      clientId: d.clientId,
      clientName: d.clientName,
      quoteName: d.quoteName,
      quoteDate: d.quoteDate,
      serviceType: d.serviceType,
      frequency: d.frequency,
      lastProClean: d.lastProClean,
      status: d.status,
      total: d.total,
      address: d.address,
      totalSqFt: d.totalSqFt,
      useTotalSqFt: d.useTotalSqFt,
      estimatedSqFt: d.estimatedSqFt,
      petsPresent: d.petsPresent,
      homeOccupied: d.homeOccupied,
      entryCode: d.entryCode,
      paymentMethod: d.paymentMethod,
      feedbackDiscussed: d.feedbackDiscussed,
      laborRate: d.laborRate,
      taxEnabled: d.taxEnabled,
      ccEnabled: d.ccEnabled,
      taxRate: d.taxRate,
      ccRate: d.ccRate,
      pricingProfileId: d.pricingProfileId,
      defaultRoomType: d.defaultRoomType,
      defaultLevel: d.defaultLevel,
      defaultSize: d.defaultSize,
      defaultComplexity: d.defaultComplexity,
      subItemType: d.subItemType,
      specialNotes: d.specialNotes,
      items: d.items,
    );
  }

  Future<void> updateQuote(String quoteId, QuoteDraft d) async {
    await setQuote(quoteId, d, isNew: false);
  }

  Future<void> restoreQuote(String quoteId, QuoteDraft d) async {
    await setQuote(quoteId, d, isNew: true);
  }

  Future<void> deleteQuote(String quoteId) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.quotes)..where((tbl) => tbl.id.equals(quoteId))).write(
      QuotesCompanion(
        deleted: const Value(true),
        updatedAt: Value(now),
      ),
    );
    await _insertOutbox(
      entityType: 'quote',
      entityId: quoteId,
      opType: 'delete',
      payload: {'deleted': true, 'updatedAt': now},
      orgId: orgId,
      updatedAt: now,
    );
  }

  Future<List<Quote>> _mapQuotes(List<QuoteRow> rows) async {
    final quotes = <Quote>[];
    for (final row in rows) {
      quotes.add(await _mapQuoteRow(row));
    }
    return quotes;
  }

  Future<Quote?> _mapQuoteRowOrNull(QuoteRow? row) async {
    if (row == null) {
      return null;
    }
    return _mapQuoteRow(row);
  }

  Future<Quote> _mapQuoteRow(QuoteRow row) async {
    final items = await _loadQuoteItems(row.id);
    return Quote(
      id: row.id,
      clientId: row.clientId,
      clientName: row.clientName,
      quoteName: row.quoteName,
      quoteDate: row.quoteDate,
      serviceType: row.serviceType,
      frequency: row.frequency,
      lastProClean: row.lastProClean,
      status: row.status.isEmpty ? 'Draft' : row.status,
      total: row.total,
      address: row.address,
      totalSqFt: row.totalSqFt,
      useTotalSqFt: row.useTotalSqFt,
      estimatedSqFt: row.estimatedSqFt,
      petsPresent: row.petsPresent,
      homeOccupied: row.homeOccupied,
      entryCode: row.entryCode,
      paymentMethod: row.paymentMethod,
      feedbackDiscussed: row.feedbackDiscussed,
      laborRate: row.laborRate,
      taxEnabled: row.taxEnabled,
      ccEnabled: row.ccEnabled,
      taxRate: row.taxRate,
      ccRate: row.ccRate,
      pricingProfileId: row.pricingProfileId,
      defaultRoomType: row.defaultRoomType,
      defaultLevel: row.defaultLevel,
      defaultSize: row.defaultSize,
      defaultComplexity: row.defaultComplexity,
      subItemType: row.subItemType,
      specialNotes: row.specialNotes,
      items: items,
    );
  }

  Future<List<Map<String, dynamic>>> _loadQuoteItems(String quoteId) async {
    final items = await _db.loadQuoteItems(quoteId);
    final ordered = items.where((item) => !item.deleted).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return ordered.map((item) => _decodeItem(item.payload)).toList();
  }

  QuotesCompanion _quoteCompanion(
    String id,
    String orgId,
    QuoteDraft d,
    int updatedAt,
  ) {
    return QuotesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      updatedAt: Value(updatedAt),
      deleted: const Value(false),
      clientId: Value(d.clientId.trim()),
      clientName: Value(d.clientName.trim()),
      quoteName: Value(d.quoteName.trim()),
      quoteDate: Value(d.quoteDate.trim()),
      serviceType: Value(d.serviceType.trim()),
      frequency: Value(d.frequency.trim()),
      lastProClean: Value(d.lastProClean.trim()),
      status: Value(d.status.trim()),
      total: Value(d.total),
      address: Value(d.address.trim()),
      totalSqFt: Value(d.totalSqFt.trim()),
      useTotalSqFt: Value(d.useTotalSqFt),
      estimatedSqFt: Value(d.estimatedSqFt.trim()),
      petsPresent: Value(d.petsPresent),
      homeOccupied: Value(d.homeOccupied),
      entryCode: Value(d.entryCode.trim()),
      paymentMethod: Value(d.paymentMethod.trim()),
      feedbackDiscussed: Value(d.feedbackDiscussed),
      laborRate: Value(d.laborRate),
      taxEnabled: Value(d.taxEnabled),
      ccEnabled: Value(d.ccEnabled),
      taxRate: Value(d.taxRate),
      ccRate: Value(d.ccRate),
      pricingProfileId: Value(d.pricingProfileId.trim()),
      defaultRoomType: Value(d.defaultRoomType.trim()),
      defaultLevel: Value(d.defaultLevel.trim()),
      defaultSize: Value(d.defaultSize.trim()),
      defaultComplexity: Value(d.defaultComplexity.trim()),
      subItemType: Value(d.subItemType.trim()),
      specialNotes: Value(d.specialNotes.trim()),
    );
  }

  Future<void> _replaceItems(
    String quoteId,
    String orgId,
    List<Map<String, dynamic>> items,
    int updatedAt,
  ) async {
    final rows = <QuoteItemRow>[];
    for (var i = 0; i < items.length; i++) {
      rows.add(
        QuoteItemRow(
          id: _uuid.v4(),
          orgId: orgId,
          quoteId: quoteId,
          updatedAt: updatedAt,
          deleted: false,
          sortOrder: i,
          payload: jsonEncode(items[i]),
        ),
      );
    }
    await _db.replaceQuoteItems(quoteId, rows);
  }

  Map<String, dynamic> _decodeItem(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return const <String, dynamic>{};
  }

  Future<void> _insertOutbox({
    required String entityType,
    required String entityId,
    required String opType,
    required Map<String, dynamic> payload,
    required String orgId,
    required int updatedAt,
  }) async {
    final existing =
        await (_db.select(_db.outbox)
              ..where(
                (tbl) =>
                    tbl.orgId.equals(orgId) &
                    tbl.entityType.equals(entityType) &
                    tbl.entityId.equals(entityId) &
                    tbl.status.equals('pending'),
              )
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) {
      await (_db.update(_db.outbox)..where((tbl) => tbl.id.equals(existing.id)))
          .write(
        OutboxCompanion(
          opType: Value(opType),
          payload: Value(jsonEncode(payload)),
          updatedAt: Value(updatedAt),
          status: const Value('pending'),
        ),
      );
    } else {
      await _db.into(_db.outbox).insert(
        OutboxCompanion(
          id: Value(_uuid.v4()),
          entityType: Value(entityType),
          entityId: Value(entityId),
          opType: Value(opType),
          payload: Value(jsonEncode(payload)),
          updatedAt: Value(updatedAt),
          orgId: Value(orgId),
          status: const Value('pending'),
        ),
      );
    }
    unawaited(_syncService.sync());
  }
}

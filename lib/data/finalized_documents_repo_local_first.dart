import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'finalized_document_models.dart';
import 'local_db.dart';
import 'quote_models.dart';
import 'session_controller.dart';
import 'sync_service.dart';

class FinalizedDocumentsRepositoryLocalFirst {
  FinalizedDocumentsRepositoryLocalFirst({
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

  Stream<List<FinalizedDocument>> streamForQuote(String quoteId) async* {
    final controller = StreamController<List<FinalizedDocument>>();
    StreamSubscription<List<FinalizedDocument>>? dataSub;

    Future<void> listenSession(AppSession? session) async {
      await dataSub?.cancel();
      if (session == null || session.orgId == null) {
        controller.add(const []);
        return;
      }
      dataSub = (_db.select(_db.finalizedDocuments)
            ..where(
              (tbl) =>
                  tbl.orgId.equals(session.orgId!) &
                  tbl.quoteId.equals(quoteId),
            )
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
          .watch()
          .map((rows) => rows.map(_mapRow).toList())
          .listen(controller.add, onError: controller.addError);
    }

    await listenSession(_sessionController.value);
    final sessionSub = _sessionController.stream.listen(listenSession);
    controller.onCancel = () async {
      await dataSub?.cancel();
      await sessionSub.cancel();
    };

    yield* controller.stream;
  }

  Future<List<FinalizedDocument>> listRecent({int limit = 25}) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      return const [];
    }
    final rows = await (_db.select(_db.finalizedDocuments)
          ..where((tbl) => tbl.orgId.equals(orgId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
          ..limit(limit))
        .get();
    return rows.map(_mapRow).toList();
  }

  Future<FinalizedDocument> createFinalizedDoc({
    String? id,
    required String quoteId,
    required String docType,
    required String status,
    required String localPath,
    String? remotePath,
    required Map<String, dynamic> quoteSnapshot,
    required Map<String, dynamic> pricingSnapshot,
    required Map<String, dynamic> totalsSnapshot,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final docId = id ?? _uuid.v4();
    final row = FinalizedDocumentsCompanion(
      id: Value(docId),
      orgId: Value(orgId),
      quoteId: Value(quoteId),
      docType: Value(docType),
      createdAt: Value(now),
      updatedAt: Value(now),
      status: Value(status),
      localPath: Value(localPath),
      remotePath: Value(remotePath),
      quoteSnapshot: Value(jsonEncode(quoteSnapshot)),
      pricingSnapshot: Value(jsonEncode(pricingSnapshot)),
      totalsSnapshot: Value(jsonEncode(totalsSnapshot)),
    );
    await _db.into(_db.finalizedDocuments).insert(row);
    await _insertOutbox(
      entityType: 'finalized_document',
      entityId: docId,
      opType: 'create',
      payload: {
        'id': docId,
        'orgId': orgId,
        'quoteId': quoteId,
        'docType': docType,
        'createdAt': now,
        'updatedAt': now,
        'status': status,
        'localPath': localPath,
        'remotePath': remotePath,
        'quoteSnapshot': quoteSnapshot,
        'pricingSnapshot': pricingSnapshot,
        'totalsSnapshot': totalsSnapshot,
        'deleted': false,
      },
      orgId: orgId,
      updatedAt: now,
    );
    return _mapRow(
      FinalizedDocumentRow(
        id: docId,
        orgId: orgId,
        quoteId: quoteId,
        docType: docType,
        createdAt: now,
        updatedAt: now,
        status: status,
        localPath: localPath,
        remotePath: remotePath,
        quoteSnapshot: jsonEncode(quoteSnapshot),
        pricingSnapshot: jsonEncode(pricingSnapshot),
        totalsSnapshot: jsonEncode(totalsSnapshot),
      ),
    );
  }

  Future<void> markSent(String id) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.finalizedDocuments)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      FinalizedDocumentsCompanion(
        status: const Value('sent'),
        updatedAt: Value(now),
      ),
    );
    await _insertOutbox(
      entityType: 'finalized_document',
      entityId: id,
      opType: 'update',
      payload: {
        'status': 'sent',
        'updatedAt': now,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  FinalizedDocument _mapRow(FinalizedDocumentRow row) {
    return FinalizedDocument(
      id: row.id,
      orgId: row.orgId,
      quoteId: row.quoteId,
      docType: row.docType,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      status: row.status,
      localPath: row.localPath,
      remotePath: row.remotePath,
      quoteSnapshot: FinalizedDocument.decodeSnapshot(row.quoteSnapshot),
      pricingSnapshot: FinalizedDocument.decodeSnapshot(row.pricingSnapshot),
      totalsSnapshot: FinalizedDocument.decodeSnapshot(row.totalsSnapshot),
    );
  }

  Map<String, dynamic> buildQuoteSnapshot(Quote quote) {
    return {
      'id': quote.id,
      'clientId': quote.clientId,
      'clientName': quote.clientName,
      'quoteName': quote.quoteName,
      'quoteDate': quote.quoteDate,
      'serviceType': quote.serviceType,
      'frequency': quote.frequency,
      'lastProClean': quote.lastProClean,
      'status': quote.status,
      'total': quote.total,
      'address': quote.address,
      'totalSqFt': quote.totalSqFt,
      'useTotalSqFt': quote.useTotalSqFt,
      'estimatedSqFt': quote.estimatedSqFt,
      'petsPresent': quote.petsPresent,
      'homeOccupied': quote.homeOccupied,
      'entryCode': quote.entryCode,
      'paymentMethod': quote.paymentMethod,
      'feedbackDiscussed': quote.feedbackDiscussed,
      'laborRate': quote.laborRate,
      'taxEnabled': quote.taxEnabled,
      'ccEnabled': quote.ccEnabled,
      'taxRate': quote.taxRate,
      'ccRate': quote.ccRate,
      'pricingProfileId': quote.pricingProfileId,
      'defaultRoomType': quote.defaultRoomType,
      'defaultLevel': quote.defaultLevel,
      'defaultSize': quote.defaultSize,
      'defaultComplexity': quote.defaultComplexity,
      'subItemType': quote.subItemType,
      'specialNotes': quote.specialNotes,
      'items': quote.items,
      'pets': quote.pets.map((pet) => pet.toMap()).toList(),
      'householdMembers':
          quote.householdMembers.map((member) => member.toMap()).toList(),
    };
  }

  Map<String, dynamic> buildTotalsSnapshot({
    required double minutes,
    required double hours,
    required double subtotal,
    required double tax,
    required double ccFee,
    required double total,
  }) {
    return {
      'minutes': minutes,
      'hours': hours,
      'subtotal': subtotal,
      'tax': tax,
      'ccFee': ccFee,
      'total': total,
    };
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
    _syncService.requestUpload(reason: 'finalized_document_change');
  }
}

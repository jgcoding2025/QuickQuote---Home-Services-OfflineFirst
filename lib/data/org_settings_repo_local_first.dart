import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'local_db.dart';
import 'org_settings_models.dart';
import 'session_controller.dart';
import 'sync_service.dart';

class OrgSettingsRepositoryLocalFirst {
  OrgSettingsRepositoryLocalFirst({
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

  Stream<OrgSettings> stream() async* {
    final controller = StreamController<OrgSettings>();
    StreamSubscription<OrgSettings>? dataSub;

    void listenSession(AppSession? session) {
      dataSub?.cancel();
      if (session == null || session.orgId == null) {
        controller.add(OrgSettings.defaults);
        return;
      }
      dataSub = _db.watchOrgSettings(session.orgId!).map((row) {
        if (row == null) {
          return OrgSettings.defaults;
        }
        return OrgSettings(
          laborRate: row.laborRate,
          taxEnabled: row.taxEnabled,
          taxRate: row.taxRate,
          ccEnabled: row.ccEnabled,
          ccRate: row.ccRate,
        );
      }).listen(
        controller.add,
        onError: controller.addError,
      );
    }

    listenSession(_sessionController.value);
    final sessionSub = _sessionController.stream.listen(listenSession);

    controller.onCancel = () async {
      await dataSub?.cancel();
      await sessionSub.cancel();
    };

    yield* controller.stream;
  }

  Future<void> save(OrgSettings settings) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertOrgSettings(
      OrgSettingsTableCompanion(
        orgId: Value(orgId),
        updatedAt: Value(now),
        deleted: const Value(false),
        laborRate: Value(settings.laborRate),
        taxEnabled: Value(settings.taxEnabled),
        taxRate: Value(settings.taxRate),
        ccEnabled: Value(settings.ccEnabled),
        ccRate: Value(settings.ccRate),
      ),
    );
    await _insertOutbox(
      entityType: 'org_settings',
      entityId: orgId,
      opType: 'update',
      payload: settings.toMap(updatedAt: now),
      orgId: orgId,
      updatedAt: now,
    );
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

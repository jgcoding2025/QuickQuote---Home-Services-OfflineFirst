import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'local_db.dart';
import 'org_settings_models.dart';
import 'session_controller.dart';

class OrgSettingsRepositoryLocalFirst {
  OrgSettingsRepositoryLocalFirst({
    required AppDatabase db,
    required SessionController sessionController,
    Uuid? uuid,
  })  : _db = db,
        _sessionController = sessionController,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final SessionController _sessionController;
  final Uuid _uuid;

  Stream<OrgSettings> stream() async* {
    final controller = StreamController<OrgSettings>();
    StreamSubscription<OrgSettingsRow?>? dataSub;

    void listenSession(AppSession? session) {
      dataSub?.cancel();
      if (session == null) {
        return;
      }
      dataSub = _db.watchOrgSettings(session.orgId).map((row) {
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
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertOrgSettings(
      OrgSettingsTableCompanion(
        orgId: Value(session.orgId),
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
      entityId: session.orgId,
      opType: 'update',
      payload: settings.toMap(updatedAt: now),
      orgId: session.orgId,
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

}

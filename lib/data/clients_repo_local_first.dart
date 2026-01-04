import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'client_models.dart';
import 'local_db.dart';
import 'session_controller.dart';
import 'sync_service.dart';

class ClientsRepositoryLocalFirst {
  ClientsRepositoryLocalFirst({
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

  String newClientId() => _uuid.v4();

  Stream<List<Client>> streamClients() async* {
    final controller = StreamController<List<Client>>();
    StreamSubscription<List<Client>>? dataSub;

    void listenSession(AppSession? session) {
      dataSub?.cancel();
      if (session == null || session.orgId == null) {
        controller.add(const []);
        return;
      }
      dataSub = _db
          .watchClients(session.orgId!)
          .map((rows) => rows.map(_clientFromRow).toList())
          .listen(
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

  Future<void> setClient(
    String clientId,
    ClientDraft d, {
    required bool isNew,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertClient(
      ClientsCompanion(
        id: Value(clientId),
        orgId: Value(orgId),
        updatedAt: Value(now),
        deleted: const Value(false),
        firstName: Value(d.firstName.trim()),
        lastName: Value(d.lastName.trim()),
        street1: Value(d.street1.trim()),
        street2: Value(d.street2.trim()),
        city: Value(d.city.trim()),
        state: Value(d.state.trim()),
        zip: Value(d.zip.trim()),
        phone: Value(d.phone.trim()),
        email: Value(d.email.trim()),
        notes: Value(d.notes.trim()),
      ),
    );
    await _insertOutbox(
      entityType: 'client',
      entityId: clientId,
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

  Future<void> deleteClient(String clientId) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.clients)..where((tbl) => tbl.id.equals(clientId)))
        .write(
      ClientsCompanion(
        deleted: const Value(true),
        updatedAt: Value(now),
      ),
    );
    await _insertOutbox(
      entityType: 'client',
      entityId: clientId,
      opType: 'delete',
      payload: {'deleted': true, 'updatedAt': now},
      orgId: orgId,
      updatedAt: now,
    );
  }

  Future<void> restoreClient(String clientId, ClientDraft draft) async {
    await setClient(clientId, draft, isNew: true);
  }

  Client _clientFromRow(ClientRow row) {
    return Client(
      id: row.id,
      firstName: row.firstName,
      lastName: row.lastName,
      street1: row.street1,
      street2: row.street2,
      city: row.city,
      state: row.state,
      zip: row.zip,
      phone: row.phone,
      email: row.email,
      notes: row.notes,
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
    unawaited(_syncService.sync());
  }
}

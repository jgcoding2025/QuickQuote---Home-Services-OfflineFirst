import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'local_db.dart';
import 'session_controller.dart';

enum SyncStatus { online, offline, syncing, error }

class SyncService {
  SyncService({required AppDatabase db, required SessionController session})
    : _db = db,
      _sessionController = session;

  final AppDatabase _db;
  final SessionController _sessionController;
  final _statusController = StreamController<SyncStatus>.broadcast();
  StreamSubscription<dynamic>? _connectivitySub;
  StreamSubscription<AppSession?>? _sessionSub;
  Timer? _pollingTimer;
  bool _isOnlineState = false;
  bool _pollingEnabled = true;
  SyncStatus _current = SyncStatus.offline;
  static const Duration pollingInterval = Duration(seconds: 3);

  Stream<SyncStatus> get statusStream => _statusController.stream;
  SyncStatus get currentStatus => _current;

  void _setStatus(SyncStatus status) {
    _current = status;
    _statusController.add(status);
  }

  Future<void> start() async {
    final initial = await Connectivity().checkConnectivity();
    _isOnlineState = _isOnline(initial);
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = _isOnline(results);
      _isOnlineState = isOnline;
      if (isOnline) {
        sync();
      } else {
        _setStatus(SyncStatus.offline);
      }
      _updatePolling();
    });
    _sessionSub = _sessionController.stream.listen((_) {
      _updatePolling();
    });
    _updatePolling();
  }

  Future<void> dispose() async {
    await _connectivitySub?.cancel();
    await _sessionSub?.cancel();
    _pollingTimer?.cancel();
    await _statusController.close();
  }

  Future<void> sync() async {
    final session = _sessionController.value;
    if (session == null || session.orgId == null) {
      _setStatus(SyncStatus.offline);
      return;
    }
    if (session.isGuest) {
      _setStatus(SyncStatus.offline);
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      _setStatus(SyncStatus.offline);
      return;
    }
    final connectivity = await Connectivity().checkConnectivity();
    if (!_isOnline(connectivity)) {
      _setStatus(SyncStatus.offline);
      return;
    }
    _setStatus(SyncStatus.syncing);
    try {
      await _uploadOutbox(session.orgId!);
      await _downloadChanges(session.orgId!);
      _setStatus(SyncStatus.online);
    } catch (e, st) {
      print('SYNC ERROR: $e');
      print(st);
      _setStatus(SyncStatus.error);
    }
  }

  Future<void> runOnce() async {
    await sync();
  }

  bool get canSyncNow => _isOnlineState && _hasValidSession();

  Future<void> flushOutboxNow() async {
    if (!_canSyncNow()) {
      return;
    }
    final session = _sessionController.value;
    if (session == null || session.orgId == null) {
      return;
    }
    _setStatus(SyncStatus.syncing);
    try {
      await _uploadOutbox(session.orgId!);
      _setStatus(SyncStatus.online);
    } catch (e, st) {
      print('OUTBOX UPLOAD ERROR: $e');
      print(st);
      _setStatus(SyncStatus.error);
    }
  }

  Future<void> downloadChangesOnce() async {
    if (!_canSyncNow()) {
      return;
    }
    final session = _sessionController.value;
    if (session == null || session.orgId == null) {
      return;
    }
    try {
      await _downloadClients(session.orgId!);
      await _downloadQuotes(session.orgId!);
    } catch (e, st) {
      print('DOWNLOAD ERROR: $e');
      print(st);
    }
  }

  void startPolling() {
    _pollingEnabled = true;
    _updatePolling();
  }

  void stopPolling() {
    _pollingEnabled = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _uploadOutbox(String orgId) async {
    final pending =
        await (_db.select(_db.outbox)
              ..where(
                (tbl) => tbl.orgId.equals(orgId) & tbl.status.equals('pending'),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
            .get();
    for (final item in pending) {
      final payload = _decodePayload(item.payload);
      final updatedAt = payload['updatedAt'] is int
          ? payload['updatedAt'] as int
          : item.updatedAt;
      final doc = _docForEntity(orgId, item.entityType, item.entityId);
      if (doc == null) {
        continue;
      }
      final data = <String, dynamic>{
        ...payload,
        'updatedAt': updatedAt,
        'deleted': payload['deleted'] == true || item.opType == 'delete',
      };
      await doc.set(data, SetOptions(merge: true));
      await (_db.update(_db.outbox)..where((tbl) => tbl.id.equals(item.id)))
          .write(OutboxCompanion(status: const Value('synced')));
    }
  }

  bool _isOnline(dynamic value) {
    if (value is ConnectivityResult) {
      return value != ConnectivityResult.none;
    }
    if (value is List<ConnectivityResult>) {
      return value.isNotEmpty &&
          !value.contains(ConnectivityResult.none) &&
          value.any((result) => result != ConnectivityResult.none);
    }
    return false;
  }

  Future<void> _downloadChanges(String orgId) async {
    await _downloadClients(orgId);
    await _downloadQuotes(orgId);
    await _downloadOrgSettings(orgId);
  }

  Future<void> _downloadClients(String orgId) async {
    final lastSync = await _db.getLastSync('client', orgId);
    final snap = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgId)
        .collection('clients')
        .where('updatedAt', isGreaterThan: lastSync)
        .get();
    var maxUpdatedAt = lastSync;
    for (final doc in snap.docs) {
      final data = doc.data();
      final updatedAt = (data['updatedAt'] as int?) ?? 0;
      final hasPending = await _hasPendingOutbox(
        entityType: 'client',
        entityId: doc.id,
        orgId: orgId,
      );
      if (hasPending) {
        continue;
      }
      if (updatedAt > maxUpdatedAt) {
        maxUpdatedAt = updatedAt;
      }
      final existing =
          await (_db.select(_db.clients)
                ..where((tbl) => tbl.id.equals(doc.id))
                ..limit(1))
              .getSingleOrNull();
      if (existing != null && existing.updatedAt >= updatedAt) {
        continue;
      }
      final deleted = data['deleted'] == true;
      await _db.upsertClient(
        ClientsCompanion(
          id: Value(doc.id),
          orgId: Value(orgId),
          updatedAt: Value(updatedAt),
          deleted: Value(deleted),
          firstName: Value(_string(data['firstName'])),
          lastName: Value(_string(data['lastName'])),
          street1: Value(_string(data['street1'])),
          street2: Value(_string(data['street2'])),
          city: Value(_string(data['city'])),
          state: Value(_string(data['state'])),
          zip: Value(_string(data['zip'])),
          phone: Value(_string(data['phone'])),
          email: Value(_string(data['email'])),
          notes: Value(_string(data['notes'])),
        ),
      );
    }
    await _db.setSyncState('client', orgId, maxUpdatedAt);
  }

  Future<void> _downloadQuotes(String orgId) async {
    final lastSync = await _db.getLastSync('quote', orgId);
    final snap = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgId)
        .collection('quotes')
        .where('updatedAt', isGreaterThan: lastSync)
        .get();
    var maxUpdatedAt = lastSync;
    for (final doc in snap.docs) {
      final data = doc.data();
      final updatedAt = (data['updatedAt'] as int?) ?? 0;
      final hasPending = await _hasPendingOutbox(
        entityType: 'quote',
        entityId: doc.id,
        orgId: orgId,
      );
      if (hasPending) {
        continue;
      }
      if (updatedAt > maxUpdatedAt) {
        maxUpdatedAt = updatedAt;
      }
      final existing =
          await (_db.select(_db.quotes)
                ..where((tbl) => tbl.id.equals(doc.id))
                ..limit(1))
              .getSingleOrNull();
      if (existing != null && existing.updatedAt >= updatedAt) {
        continue;
      }
      final deleted = data['deleted'] == true;
      await _db.upsertQuote(
        QuotesCompanion(
          id: Value(doc.id),
          orgId: Value(orgId),
          updatedAt: Value(updatedAt),
          deleted: Value(deleted),
          clientId: Value(_string(data['clientId'])),
          clientName: Value(_string(data['clientName'])),
          quoteName: Value(_string(data['quoteName'])),
          quoteDate: Value(_string(data['quoteDate'])),
          serviceType: Value(_string(data['serviceType'])),
          frequency: Value(_string(data['frequency'])),
          lastProClean: Value(_string(data['lastProClean'])),
          status: Value(_string(data['status'])),
          total: Value(_num(data['total'])),
          address: Value(_string(data['address'])),
          totalSqFt: Value(_string(data['totalSqFt'])),
          useTotalSqFt: Value(_bool(data['useTotalSqFt'], fallback: true)),
          estimatedSqFt: Value(_string(data['estimatedSqFt'])),
          petsPresent: Value(_bool(data['petsPresent'])),
          homeOccupied: Value(_bool(data['homeOccupied'], fallback: true)),
          entryCode: Value(_string(data['entryCode'])),
          paymentMethod: Value(_string(data['paymentMethod'])),
          feedbackDiscussed: Value(_bool(data['feedbackDiscussed'])),
          laborRate: Value(_num(data['laborRate'], fallback: 40.0)),
          taxEnabled: Value(_bool(data['taxEnabled'])),
          ccEnabled: Value(_bool(data['ccEnabled'])),
          taxRate: Value(_num(data['taxRate'], fallback: 0.07)),
          ccRate: Value(_num(data['ccRate'], fallback: 0.03)),
          defaultRoomType: Value(_string(data['defaultRoomType'])),
          defaultLevel: Value(_string(data['defaultLevel'])),
          defaultSize: Value(_string(data['defaultSize'])),
          defaultComplexity: Value(_string(data['defaultComplexity'])),
          subItemType: Value(_string(data['subItemType'])),
          specialNotes: Value(_string(data['specialNotes'])),
        ),
      );
      final rawItems = data['items'];
      final items = rawItems is List
          ? rawItems.whereType<Map<String, dynamic>>().toList()
          : <Map<String, dynamic>>[];
      await _replaceQuoteItems(orgId, doc.id, items, updatedAt);
    }
    await _db.setSyncState('quote', orgId, maxUpdatedAt);
  }

  Future<void> _downloadOrgSettings(String orgId) async {
    final lastSync = await _db.getLastSync('org_settings', orgId);
    final doc = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgId)
        .collection('settings')
        .doc('defaults')
        .get();
    final data = doc.data();
    if (data == null) {
      return;
    }
    final updatedAt = (data['updatedAt'] as int?) ?? 0;
    if (updatedAt <= lastSync) {
      return;
    }
    final existing =
        await (_db.select(_db.orgSettingsTable)
              ..where((tbl) => tbl.orgId.equals(orgId))
              ..limit(1))
            .getSingleOrNull();
    if (existing != null && existing.updatedAt >= updatedAt) {
      return;
    }
    await _db.upsertOrgSettings(
      OrgSettingsTableCompanion(
        orgId: Value(orgId),
        updatedAt: Value(updatedAt),
        deleted: Value(data['deleted'] == true),
        laborRate: Value(_num(data['laborRate'], fallback: 40.0)),
        taxEnabled: Value(_bool(data['taxEnabled'])),
        taxRate: Value(_num(data['taxRate'], fallback: 0.07)),
        ccEnabled: Value(_bool(data['ccEnabled'])),
        ccRate: Value(_num(data['ccRate'], fallback: 0.03)),
      ),
    );
    await _db.setSyncState('org_settings', orgId, updatedAt);
  }

  Future<void> _replaceQuoteItems(
    String orgId,
    String quoteId,
    List<Map<String, dynamic>> items,
    int updatedAt,
  ) async {
    final rows = <QuoteItemRow>[];
    for (var i = 0; i < items.length; i++) {
      rows.add(
        QuoteItemRow(
          id: '${quoteId}_$i',
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

  Future<bool> _hasPendingOutbox({
    required String entityType,
    required String entityId,
    required String orgId,
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
    return existing != null;
  }

  void _updatePolling() {
    if (!_pollingEnabled) {
      return;
    }
    if (_shouldPoll()) {
      _pollingTimer ??= Timer.periodic(pollingInterval, (_) {
        if (_shouldPoll()) {
          unawaited(downloadChangesOnce());
        }
      });
    } else {
      _pollingTimer?.cancel();
      _pollingTimer = null;
    }
  }

  bool _hasValidSession() {
    final session = _sessionController.value;
    if (session == null || session.orgId == null) {
      return false;
    }
    if (session.isGuest) {
      return false;
    }
    return FirebaseAuth.instance.currentUser != null;
  }

  bool _canSyncNow() {
    return _isOnlineState && _hasValidSession();
  }

  bool _shouldPoll() => _canSyncNow();

  DocumentReference<Map<String, dynamic>>? _docForEntity(
    String orgId,
    String entityType,
    String entityId,
  ) {
    final firestore = FirebaseFirestore.instance;
    switch (entityType) {
      case 'client':
        return firestore
            .collection('orgs')
            .doc(orgId)
            .collection('clients')
            .doc(entityId);
      case 'quote':
        return firestore
            .collection('orgs')
            .doc(orgId)
            .collection('quotes')
            .doc(entityId);
      case 'org_settings':
        return firestore
            .collection('orgs')
            .doc(orgId)
            .collection('settings')
            .doc('defaults');
    }
    return null;
  }

  Map<String, dynamic> _decodePayload(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return const <String, dynamic>{};
  }

  double _num(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  bool _bool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return fallback;
  }

  String _string(dynamic value) {
    return value?.toString() ?? '';
  }
}

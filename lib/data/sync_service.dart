import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'local_db.dart';
import 'presence_service.dart';
import 'session_controller.dart';
import 'metrics_collector.dart';

enum SyncStatus { online, offline, syncing, error }

enum DebugState { paused, enabled, syncing, error, manual, armed, active }

class SyncDebugInfo {
  const SyncDebugInfo({
    required this.uploadLabel,
    required this.downloadLabel,
    required this.uploadState,
    required this.downloadState,
    required this.lastUploadAt,
    required this.lastDownloadAt,
  });

  final String uploadLabel;
  final String downloadLabel;
  final DebugState uploadState;
  final DebugState downloadState;
  final DateTime? lastUploadAt;
  final DateTime? lastDownloadAt;
}

class SyncService {
  SyncService({
    required AppDatabase db,
    required SessionController session,
    required PresenceService presenceService,
    MetricsCollector? metricsCollector,
  })  : _db = db,
        _sessionController = session,
        _presenceService = presenceService,
        _metricsCollector = metricsCollector ?? const NoopMetricsCollector();

  final AppDatabase _db;
  final SessionController _sessionController;
  final PresenceService _presenceService;
  final MetricsCollector _metricsCollector;
  final _statusController = StreamController<SyncStatus>.broadcast();
  final ValueNotifier<int> _debugTick = ValueNotifier<int>(0);
  StreamSubscription<dynamic>? _connectivitySub;
  StreamSubscription<AppSession?>? _sessionSub;
  StreamSubscription<bool>? _presenceSub;
  Timer? _downloadPollingTimer;
  Timer? _uploadDebounceTimer;
  Timer? _uploadSafetyTimer;
  bool _isOnlineState = false;
  bool _downloadPollingEnabled = false;
  SyncStatus _current = SyncStatus.offline;
  Future<void>? _uploadInFlight;
  Future<void>? _downloadInFlight;
  static const Duration downloadPollingInterval = Duration(seconds: 3);
  static const Duration uploadDebounce = Duration(seconds: 2);
  static const Duration safetyUploadInterval = Duration(minutes: 10);
  Duration _downloadPollingInterval = downloadPollingInterval;
  DateTime? _lastUploadAtLocal;
  DateTime? _lastDownloadAtLocal;
  DateTime? _nextAllowedSyncAt;

  Stream<SyncStatus> get statusStream => _statusController.stream;
  SyncStatus get currentStatus => _current;
  bool get hasPeerOnline => _presenceService.hasPeerOnline;
  Stream<bool> get hasPeerOnlineStream =>
      _presenceService.hasPeerOnlineStream;
  ValueListenable<int> get debugTick => _debugTick;
  DateTime? get lastUploadAtLocal => _lastUploadAtLocal;
  DateTime? get lastDownloadAtLocal => _lastDownloadAtLocal;
  bool get isPollingEnabled => _downloadPollingEnabled;
  bool get isPollingActive => _downloadPollingTimer != null;
  Duration get pollingInterval => _downloadPollingInterval;
  Duration get uploadDebounceInterval => uploadDebounce;
  Duration get safetyUploadEvery => safetyUploadInterval;
  DateTime? get nextAllowedSyncAt => _nextAllowedSyncAt;

  void _setStatus(SyncStatus status) {
    if (_current == status) {
      return;
    }
    _current = status;
    _statusController.add(status);
    _notifyDebug();
  }

  Future<void> start() async {
    await _presenceService.start();
    final initial = await Connectivity().checkConnectivity();
    _isOnlineState = _isOnline(initial);
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = _isOnline(results);
      _isOnlineState = isOnline;
      if (!isOnline) {
        _setStatus(SyncStatus.offline);
      }
      _notifyDebug();
      _syncPresenceAndPolling();
      if (isOnline) {
        requestUpload(reason: 'connectivity_online');
      }
    });
    _sessionSub = _sessionController.stream.listen((_) {
      _syncPresenceAndPolling();
      if (_canSyncNow()) {
        requestUpload(reason: 'session_ready');
      }
    });
    _presenceSub = _presenceService.hasPeerOnlineStream.listen((hasPeer) {
      if (hasPeer) {
        unawaited(downloadNow(reason: 'peer_online'));
      }
      _updateDownloadPolling();
      _notifyDebug();
    });
    _syncPresenceAndPolling();
    _startUploadSafetyTimer();
    _updateDownloadPolling();
  }

  Future<void> dispose() async {
    await _connectivitySub?.cancel();
    await _sessionSub?.cancel();
    await _presenceSub?.cancel();
    _downloadPollingTimer?.cancel();
    _uploadDebounceTimer?.cancel();
    _uploadSafetyTimer?.cancel();
    await _presenceService.dispose();
    await _statusController.close();
    _debugTick.dispose();
  }

  Future<void> sync({String reason = 'manual'}) async {
    await uploadNow(reason: '$reason:upload');
    await downloadNow(reason: '$reason:download');
  }

  Future<void> runOnce() async {
    await sync(reason: 'run_once');
  }

  bool get canSyncNow => _isOnlineState && _hasValidSession();

  void requestUpload({String reason = 'unspecified'}) {
    _uploadDebounceTimer?.cancel();
    _nextAllowedSyncAt = DateTime.now().add(uploadDebounce);
    _notifyDebug();
    _uploadDebounceTimer = Timer(uploadDebounce, () {
      _nextAllowedSyncAt = null;
      _notifyDebug();
      unawaited(uploadNow(reason: reason));
    });
  }

  Future<void> uploadNow({String reason = 'manual'}) {
    return _uploadInFlight ??= _uploadOnce(reason).whenComplete(() {
          _uploadInFlight = null;
        });
  }

  Future<void> downloadNow({String reason = 'manual'}) {
    return _downloadInFlight ??= _downloadOnce(reason).whenComplete(() {
          _downloadInFlight = null;
        });
  }

  Future<void> flushOutboxNow() async {
    await uploadNow(reason: 'flush_outbox');
  }

  Future<void> downloadChangesOnce() async {
    await downloadNow(reason: 'download_once');
  }

  void startPolling({Duration? interval}) {
    _downloadPollingEnabled = true;
    if (interval != null && interval != _downloadPollingInterval) {
      _downloadPollingInterval = interval;
      _downloadPollingTimer?.cancel();
      _downloadPollingTimer = null;
    }
    _updateDownloadPolling();
    _notifyDebug();
  }

  void stopPolling() {
    _downloadPollingEnabled = false;
    _downloadPollingTimer?.cancel();
    _downloadPollingTimer = null;
    _notifyDebug();
  }

  Future<void> _uploadOnce(String reason) async {
    if (!_canSyncNow()) {
      return;
    }
    final session = _sessionController.value;
    if (session == null || session.orgId == null) {
      return;
    }
    _nextAllowedSyncAt = null;
    _notifyDebug();
    _setStatus(SyncStatus.syncing);
    try {
      await _uploadOutbox(session.orgId!);
      _lastUploadAtLocal = DateTime.now();
      _setStatus(SyncStatus.online);
      _notifyDebug();
      if (_presenceService.hasPeerOnline) {
        unawaited(downloadNow(reason: 'post_upload_peer_online'));
      }
    } catch (e, st) {
      debugPrint('OUTBOX UPLOAD ERROR ($reason): $e');
      debugPrint('$st');
      _setStatus(SyncStatus.error);
    }
  }

  Future<void> _downloadOnce(String reason) async {
    if (!_canSyncNow()) {
      return;
    }
    final session = _sessionController.value;
    if (session == null || session.orgId == null) {
      return;
    }
    _setStatus(SyncStatus.syncing);
    try {
      await _downloadChanges(session.orgId!);
      _lastDownloadAtLocal = DateTime.now();
      _setStatus(SyncStatus.online);
      _notifyDebug();
    } catch (e, st) {
      debugPrint('DOWNLOAD ERROR ($reason): $e');
      debugPrint('$st');
      _setStatus(SyncStatus.error);
    }
  }

  Future<void> _uploadOutbox(String orgId) async {
    final pending =
        await (_db.select(_db.outbox)
              ..where(
                (tbl) => tbl.orgId.equals(orgId) & tbl.status.equals('pending'),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
            .get();
    debugPrint('OUTBOX: ${pending.length} pending items to upload.');
    for (final item in pending) {
      final payload = _decodePayload(item.payload);
      final updatedAt = payload['updatedAt'] is int
          ? payload['updatedAt'] as int
          : item.updatedAt;
      final doc = _docForEntity(
        orgId,
        item.entityType,
        item.entityId,
        payload,
      );
      if (doc == null) {
        continue;
      }
      final data = <String, dynamic>{
        ...payload,
        'updatedAt': updatedAt,
        'deleted': payload['deleted'] == true || item.opType == 'delete',
      };
      await doc.set(data, SetOptions(merge: true));
      unawaited(_metricsCollector.recordWrite());
      debugPrint('OUTBOX: transaction start for item ${item.id}.');
      await _db.transaction(() async {
        await (_db.update(_db.outbox)..where((tbl) => tbl.id.equals(item.id)))
            .write(OutboxCompanion(status: const Value('synced')));
      });
      debugPrint('OUTBOX: transaction end for item ${item.id}.');
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
    await _downloadPricingProfiles(orgId);
    await _downloadFinalizedDocuments(orgId);
  }

  Future<void> _downloadClients(String orgId) async {
    final lastSync = await _db.getLastSync('client', orgId);
    final snap = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgId)
        .collection('clients')
        .where('updatedAt', isGreaterThan: lastSync)
        .get();
    unawaited(_metricsCollector.recordRead(count: snap.docs.length));
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
    unawaited(_metricsCollector.recordRead(count: snap.docs.length));
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
          pricingProfileId: Value(
            _string(data['pricingProfileId']).isEmpty
                ? 'default'
                : _string(data['pricingProfileId']),
          ),
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

  Future<void> _downloadFinalizedDocuments(String orgId) async {
    final lastSync = await _db.getLastSync('finalized_document', orgId);
    final snap = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgId)
        .collection('finalizedDocuments')
        .where('updatedAt', isGreaterThan: lastSync)
        .get();
    unawaited(_metricsCollector.recordRead(count: snap.docs.length));
    var maxUpdatedAt = lastSync;
    for (final doc in snap.docs) {
      final data = doc.data();
      final updatedAt = (data['updatedAt'] as int?) ?? 0;
      final hasPending = await _hasPendingOutbox(
        entityType: 'finalized_document',
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
          await (_db.select(_db.finalizedDocuments)
                ..where((tbl) => tbl.id.equals(doc.id))
                ..limit(1))
              .getSingleOrNull();
      if (existing != null && existing.updatedAt >= updatedAt) {
        continue;
      }
      await _db.into(_db.finalizedDocuments).insertOnConflictUpdate(
            FinalizedDocumentsCompanion(
              id: Value(doc.id),
              orgId: Value(orgId),
              quoteId: Value(_string(data['quoteId'])),
              docType: Value(_string(data['docType'])),
              createdAt: Value((data['createdAt'] as int?) ?? updatedAt),
              updatedAt: Value(updatedAt),
              status: Value(_string(data['status'])),
              localPath: Value(_string(data['localPath'])),
              remotePath: Value(
                _string(data['remotePath']).isEmpty
                    ? null
                    : _string(data['remotePath']),
              ),
              quoteSnapshot: Value(
                jsonEncode(data['quoteSnapshot'] ?? const {}),
              ),
              pricingSnapshot: Value(
                jsonEncode(data['pricingSnapshot'] ?? const {}),
              ),
              totalsSnapshot: Value(
                jsonEncode(data['totalsSnapshot'] ?? const {}),
              ),
            ),
          );
    }
    await _db.setSyncState('finalized_document', orgId, maxUpdatedAt);
  }

  Future<void> _downloadOrgSettings(String orgId) async {
    final lastSync = await _db.getLastSync('org_settings', orgId);
    final doc = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgId)
        .collection('settings')
        .doc('defaults')
        .get();
    unawaited(_metricsCollector.recordRead());
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
        defaultPricingProfileId: Value(
          _string(data['defaultPricingProfileId']).isEmpty
              ? 'default'
              : _string(data['defaultPricingProfileId']),
        ),
      ),
    );
    await _db.setSyncState('org_settings', orgId, updatedAt);
  }

  Future<void> _downloadPricingProfiles(String orgId) async {
    final profileIds = await _downloadPricingProfileHeaders(orgId);
    await _downloadPricingProfileServiceTypes(orgId, profileIds);
    await _downloadPricingProfileFrequencies(orgId, profileIds);
    await _downloadPricingProfileRoomTypes(orgId, profileIds);
    await _downloadPricingProfileSubItems(orgId, profileIds);
    await _downloadPricingProfileSizes(orgId, profileIds);
    await _downloadPricingProfileComplexities(orgId, profileIds);
  }

  Future<List<String>> _downloadPricingProfileHeaders(String orgId) async {
    final lastSync = await _db.getLastSync('pricing_profile', orgId);
    final snap = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgId)
        .collection('pricingProfiles')
        .get();
    unawaited(_metricsCollector.recordRead(count: snap.docs.length));
    final profileIds = <String>[];
    var maxUpdatedAt = lastSync;
    for (final doc in snap.docs) {
      final data = doc.data();
      profileIds.add(doc.id);
      final updatedAt = (data['updatedAt'] as int?) ?? 0;
      final hasPending = await _hasPendingOutbox(
        entityType: 'pricing_profile',
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
          await (_db.select(_db.pricingProfiles)
                ..where((tbl) => tbl.id.equals(doc.id))
                ..limit(1))
              .getSingleOrNull();
      if (existing != null && existing.updatedAt >= updatedAt) {
        continue;
      }
      final deleted = data['deleted'] == true;
      await _db.into(_db.pricingProfiles).insertOnConflictUpdate(
            PricingProfilesCompanion(
              id: Value(doc.id),
              orgId: Value(orgId),
              name: Value(_string(data['name'])),
              laborRate: Value(_num(data['laborRate'], fallback: 40.0)),
              taxEnabled: Value(_bool(data['taxEnabled'])),
              taxRate: Value(_num(data['taxRate'], fallback: 0.07)),
              ccEnabled: Value(_bool(data['ccEnabled'])),
              ccRate: Value(_num(data['ccRate'], fallback: 0.03)),
              updatedAt: Value(updatedAt),
              deleted: Value(deleted),
            ),
          );
    }
    await _db.setSyncState('pricing_profile', orgId, maxUpdatedAt);
    return profileIds;
  }

  Future<void> _downloadPricingProfileServiceTypes(
    String orgId,
    List<String> profileIds,
  ) async {
    final lastSync =
        await _db.getLastSync('pricing_profile_service_type', orgId);
    var maxUpdatedAt = lastSync;
    for (final profileId in profileIds) {
      final snap = await FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgId)
          .collection('pricingProfiles')
          .doc(profileId)
          .collection('serviceTypes')
          .where('updatedAt', isGreaterThan: lastSync)
          .orderBy('updatedAt')
          .get();
      unawaited(_metricsCollector.recordRead(count: snap.docs.length));
      for (final doc in snap.docs) {
        final data = doc.data();
        final updatedAt = (data['updatedAt'] as int?) ?? 0;
        final hasPending = await _hasPendingOutbox(
          entityType: 'pricing_profile_service_type',
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
            await (_db.select(_db.pricingProfileServiceTypes)
                  ..where((tbl) => tbl.id.equals(doc.id))
                  ..limit(1))
                .getSingleOrNull();
        if (existing != null && existing.updatedAt >= updatedAt) {
          continue;
        }
        await _db.into(_db.pricingProfileServiceTypes).insertOnConflictUpdate(
              PricingProfileServiceTypesCompanion(
                id: Value(doc.id),
                orgId: Value(orgId),
                profileId: Value(profileId),
                row: Value((data['row'] as num?)?.toInt() ?? 0),
                category: Value(_string(data['category']).isEmpty
                    ? 'General'
                    : _string(data['category'])),
                serviceType: Value(_string(data['serviceType'])),
                description: Value(_string(data['description'])),
                pricePerSqFt: Value(_num(data['pricePerSqFt'])),
                multiplier: Value(_num(data['multiplier'], fallback: 1)),
                updatedAt: Value(updatedAt),
                deleted: Value(data['deleted'] == true),
              ),
            );
      }
    }
    await _db.setSyncState(
      'pricing_profile_service_type',
      orgId,
      maxUpdatedAt,
    );
  }

  Future<void> _downloadPricingProfileFrequencies(
    String orgId,
    List<String> profileIds,
  ) async {
    final lastSync =
        await _db.getLastSync('pricing_profile_frequency', orgId);
    var maxUpdatedAt = lastSync;
    for (final profileId in profileIds) {
      final snap = await FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgId)
          .collection('pricingProfiles')
          .doc(profileId)
          .collection('frequencies')
          .where('updatedAt', isGreaterThan: lastSync)
          .orderBy('updatedAt')
          .get();
      unawaited(_metricsCollector.recordRead(count: snap.docs.length));
      for (final doc in snap.docs) {
        final data = doc.data();
        final updatedAt = (data['updatedAt'] as int?) ?? 0;
        final hasPending = await _hasPendingOutbox(
          entityType: 'pricing_profile_frequency',
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
            await (_db.select(_db.pricingProfileFrequencies)
                  ..where((tbl) => tbl.id.equals(doc.id))
                  ..limit(1))
                .getSingleOrNull();
        if (existing != null && existing.updatedAt >= updatedAt) {
          continue;
        }
        await _db.into(_db.pricingProfileFrequencies).insertOnConflictUpdate(
              PricingProfileFrequenciesCompanion(
                id: Value(doc.id),
                orgId: Value(orgId),
                profileId: Value(profileId),
                serviceType: Value(_string(data['serviceType'])),
                frequency: Value(_string(data['frequency'])),
                multiplier: Value(_num(data['multiplier'], fallback: 1)),
                updatedAt: Value(updatedAt),
                deleted: Value(data['deleted'] == true),
              ),
            );
      }
    }
    await _db.setSyncState(
      'pricing_profile_frequency',
      orgId,
      maxUpdatedAt,
    );
  }

  Future<void> _downloadPricingProfileRoomTypes(
    String orgId,
    List<String> profileIds,
  ) async {
    final lastSync =
        await _db.getLastSync('pricing_profile_room_type', orgId);
    var maxUpdatedAt = lastSync;
    for (final profileId in profileIds) {
      final snap = await FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgId)
          .collection('pricingProfiles')
          .doc(profileId)
          .collection('roomTypes')
          .where('updatedAt', isGreaterThan: lastSync)
          .orderBy('updatedAt')
          .get();
      unawaited(_metricsCollector.recordRead(count: snap.docs.length));
      for (final doc in snap.docs) {
        final data = doc.data();
        final updatedAt = (data['updatedAt'] as int?) ?? 0;
        final hasPending = await _hasPendingOutbox(
          entityType: 'pricing_profile_room_type',
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
            await (_db.select(_db.pricingProfileRoomTypes)
                  ..where((tbl) => tbl.id.equals(doc.id))
                  ..limit(1))
                .getSingleOrNull();
        if (existing != null && existing.updatedAt >= updatedAt) {
          continue;
        }
        await _db.into(_db.pricingProfileRoomTypes).insertOnConflictUpdate(
              PricingProfileRoomTypesCompanion(
                id: Value(doc.id),
                orgId: Value(orgId),
                profileId: Value(profileId),
                row: Value((data['row'] as num?)?.toInt() ?? 0),
                category: Value(_string(data['category']).isEmpty
                    ? 'General'
                    : _string(data['category'])),
                roomType: Value(_string(data['roomType'])),
                description: Value(_string(data['description'])),
                minutes: Value((data['minutes'] as num?)?.toInt() ?? 0),
                squareFeet: Value((data['squareFeet'] as num?)?.toInt() ?? 0),
                updatedAt: Value(updatedAt),
                deleted: Value(data['deleted'] == true),
              ),
            );
      }
    }
    await _db.setSyncState(
      'pricing_profile_room_type',
      orgId,
      maxUpdatedAt,
    );
  }

  Future<void> _downloadPricingProfileSubItems(
    String orgId,
    List<String> profileIds,
  ) async {
    final lastSync =
        await _db.getLastSync('pricing_profile_sub_item', orgId);
    var maxUpdatedAt = lastSync;
    for (final profileId in profileIds) {
      final snap = await FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgId)
          .collection('pricingProfiles')
          .doc(profileId)
          .collection('subItems')
          .where('updatedAt', isGreaterThan: lastSync)
          .orderBy('updatedAt')
          .get();
      unawaited(_metricsCollector.recordRead(count: snap.docs.length));
      for (final doc in snap.docs) {
        final data = doc.data();
        final updatedAt = (data['updatedAt'] as int?) ?? 0;
        final hasPending = await _hasPendingOutbox(
          entityType: 'pricing_profile_sub_item',
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
            await (_db.select(_db.pricingProfileSubItems)
                  ..where((tbl) => tbl.id.equals(doc.id))
                  ..limit(1))
                .getSingleOrNull();
        if (existing != null && existing.updatedAt >= updatedAt) {
          continue;
        }
        await _db.into(_db.pricingProfileSubItems).insertOnConflictUpdate(
              PricingProfileSubItemsCompanion(
                id: Value(doc.id),
                orgId: Value(orgId),
                profileId: Value(profileId),
                category: Value(_string(data['category']).isEmpty
                    ? 'General'
                    : _string(data['category'])),
                subItem: Value(_string(data['subItem'])),
                description: Value(_string(data['description'])),
                minutes: Value((data['minutes'] as num?)?.toInt() ?? 0),
                updatedAt: Value(updatedAt),
                deleted: Value(data['deleted'] == true),
              ),
            );
      }
    }
    await _db.setSyncState(
      'pricing_profile_sub_item',
      orgId,
      maxUpdatedAt,
    );
  }

  Future<void> _downloadPricingProfileSizes(
    String orgId,
    List<String> profileIds,
  ) async {
    final lastSync =
        await _db.getLastSync('pricing_profile_size', orgId);
    var maxUpdatedAt = lastSync;
    for (final profileId in profileIds) {
      final snap = await FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgId)
          .collection('pricingProfiles')
          .doc(profileId)
          .collection('sizes')
          .where('updatedAt', isGreaterThan: lastSync)
          .orderBy('updatedAt')
          .get();
      unawaited(_metricsCollector.recordRead(count: snap.docs.length));
      for (final doc in snap.docs) {
        final data = doc.data();
        final updatedAt = (data['updatedAt'] as int?) ?? 0;
        final hasPending = await _hasPendingOutbox(
          entityType: 'pricing_profile_size',
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
            await (_db.select(_db.pricingProfileSizes)
                  ..where((tbl) => tbl.id.equals(doc.id))
                  ..limit(1))
                .getSingleOrNull();
        if (existing != null && existing.updatedAt >= updatedAt) {
          continue;
        }
        await _db.into(_db.pricingProfileSizes).insertOnConflictUpdate(
              PricingProfileSizesCompanion(
                id: Value(doc.id),
                orgId: Value(orgId),
                profileId: Value(profileId),
                size: Value(_string(data['size'])),
                multiplier: Value(_num(data['multiplier'], fallback: 1)),
                definition: Value(_string(data['definition'])),
                updatedAt: Value(updatedAt),
                deleted: Value(data['deleted'] == true),
              ),
            );
      }
    }
    await _db.setSyncState(
      'pricing_profile_size',
      orgId,
      maxUpdatedAt,
    );
  }

  Future<void> _downloadPricingProfileComplexities(
    String orgId,
    List<String> profileIds,
  ) async {
    final lastSync =
        await _db.getLastSync('pricing_profile_complexity', orgId);
    var maxUpdatedAt = lastSync;
    for (final profileId in profileIds) {
      final snap = await FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgId)
          .collection('pricingProfiles')
          .doc(profileId)
          .collection('complexities')
          .where('updatedAt', isGreaterThan: lastSync)
          .orderBy('updatedAt')
          .get();
      unawaited(_metricsCollector.recordRead(count: snap.docs.length));
      for (final doc in snap.docs) {
        final data = doc.data();
        final updatedAt = (data['updatedAt'] as int?) ?? 0;
        final hasPending = await _hasPendingOutbox(
          entityType: 'pricing_profile_complexity',
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
            await (_db.select(_db.pricingProfileComplexities)
                  ..where((tbl) => tbl.id.equals(doc.id))
                  ..limit(1))
                .getSingleOrNull();
        if (existing != null && existing.updatedAt >= updatedAt) {
          continue;
        }
        await _db.into(_db.pricingProfileComplexities).insertOnConflictUpdate(
              PricingProfileComplexitiesCompanion(
                id: Value(doc.id),
                orgId: Value(orgId),
                profileId: Value(profileId),
                level: Value(_string(data['level'])),
                multiplier: Value(_num(data['multiplier'], fallback: 1)),
                definition: Value(_string(data['definition'])),
                updatedAt: Value(updatedAt),
                deleted: Value(data['deleted'] == true),
              ),
            );
      }
    }
    await _db.setSyncState(
      'pricing_profile_complexity',
      orgId,
      maxUpdatedAt,
    );
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

  Future<bool> _hasPendingOutboxForOrg(String orgId) async {
    final existing =
        await (_db.select(_db.outbox)
              ..where(
                (tbl) => tbl.orgId.equals(orgId) & tbl.status.equals('pending'),
              )
              ..limit(1))
            .getSingleOrNull();
    return existing != null;
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

  void _syncPresenceAndPolling() {
    final session = _sessionController.value;
    final orgId = session?.orgId;
    final canBeOnline = _canSyncNow();
    _presenceService.updateSession(orgId: orgId, canBeOnline: canBeOnline);
    _updateDownloadPolling();
    _notifyDebug();
  }

  void _updateDownloadPolling() {
    if (!_downloadPollingEnabled) {
      _downloadPollingTimer?.cancel();
      _downloadPollingTimer = null;
      _notifyDebug();
      return;
    }
    if (_shouldPollDownloads()) {
      _downloadPollingTimer ??=
          Timer.periodic(_downloadPollingInterval, (_) {
        if (_shouldPollDownloads()) {
          unawaited(downloadNow(reason: 'polling'));
        }
      });
    } else {
      _downloadPollingTimer?.cancel();
      _downloadPollingTimer = null;
    }
    _notifyDebug();
  }

  void _startUploadSafetyTimer() {
    _uploadSafetyTimer?.cancel();
    _uploadSafetyTimer = Timer.periodic(safetyUploadInterval, (_) async {
      if (!_canSyncNow()) {
        return;
      }
      final session = _sessionController.value;
      if (session == null || session.orgId == null) {
        return;
      }
      final hasPending = await _hasPendingOutboxForOrg(session.orgId!);
      if (hasPending) {
        requestUpload(reason: 'safety_timer');
      }
    });
  }

  bool _shouldPollDownloads() => _canSyncNow() && _presenceService.hasPeerOnline;

  SyncDebugInfo get debugInfo {
    final canSync = _canSyncNow();
    final safetyLabel = _uploadSafetyTimer != null
        ? ' + safety (${_formatDuration(safetyUploadInterval)})'
        : '';
    final uploadLabel = !canSync
        ? 'paused'
        : 'debounced (${_formatDuration(uploadDebounce)})$safetyLabel';
    final downloadLabel = !canSync
        ? 'paused'
        : !_downloadPollingEnabled
            ? 'manual'
            : !_presenceService.hasPeerOnline
                ? 'armed (peer offline)'
                : 'every ${_downloadPollingInterval.inSeconds}s';
    final uploadState = _current == SyncStatus.error
        ? DebugState.error
        : !canSync
            ? DebugState.paused
            : _uploadInFlight != null
                ? DebugState.syncing
                : DebugState.enabled;
    final downloadState = _current == SyncStatus.error
        ? DebugState.error
        : !canSync
            ? DebugState.paused
            : !_downloadPollingEnabled
                ? DebugState.manual
                : !_presenceService.hasPeerOnline
                    ? DebugState.armed
                    : DebugState.active;
    return SyncDebugInfo(
      uploadLabel: uploadLabel,
      downloadLabel: downloadLabel,
      uploadState: uploadState,
      downloadState: downloadState,
      lastUploadAt: _lastUploadAtLocal,
      lastDownloadAt: _lastDownloadAtLocal,
    );
  }

  List<String> debugBlockingReasons() {
    final reasons = <String>[];
    if (!_isOnlineState) {
      reasons.add('Offline connectivity');
    }
    final session = _sessionController.value;
    if (session == null) {
      reasons.add('No session');
    }
    final orgId = session?.orgId;
    if (orgId == null || orgId.isEmpty) {
      reasons.add('orgId missing');
    }
    if (session?.isGuest ?? false) {
      reasons.add('Guest session');
    }
    if (FirebaseAuth.instance.currentUser == null) {
      reasons.add('FirebaseAuth user null');
    }
    if (_nextAllowedSyncAt != null &&
        _nextAllowedSyncAt!.isAfter(DateTime.now())) {
      reasons.add(
        'Sync throttled until ${_formatLocalTime(_nextAllowedSyncAt!)}',
      );
    }
    if (!_downloadPollingEnabled) {
      reasons.add('Polling disabled');
    }
    if (_downloadPollingEnabled && !_presenceService.hasPeerOnline) {
      reasons.add('Peer offline (Live Mode requires peer online)');
    }
    return reasons;
  }

  DocumentReference<Map<String, dynamic>>? _docForEntity(
    String orgId,
    String entityType,
    String entityId,
    Map<String, dynamic> payload,
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
      case 'pricing_profile':
        return firestore
            .collection('orgs')
            .doc(orgId)
            .collection('pricingProfiles')
            .doc(entityId);
      case 'pricing_profile_service_type':
        return _profileSubDoc(
          firestore,
          orgId,
          payload,
          'serviceTypes',
          entityId,
        );
      case 'pricing_profile_frequency':
        return _profileSubDoc(
          firestore,
          orgId,
          payload,
          'frequencies',
          entityId,
        );
      case 'pricing_profile_room_type':
        return _profileSubDoc(
          firestore,
          orgId,
          payload,
          'roomTypes',
          entityId,
        );
      case 'pricing_profile_sub_item':
        return _profileSubDoc(
          firestore,
          orgId,
          payload,
          'subItems',
          entityId,
        );
      case 'pricing_profile_size':
        return _profileSubDoc(
          firestore,
          orgId,
          payload,
          'sizes',
          entityId,
        );
      case 'pricing_profile_complexity':
        return _profileSubDoc(
          firestore,
          orgId,
          payload,
          'complexities',
          entityId,
        );
      case 'finalized_document':
        return firestore
            .collection('orgs')
            .doc(orgId)
            .collection('finalizedDocuments')
            .doc(entityId);
    }
    return null;
  }

  DocumentReference<Map<String, dynamic>>? _profileSubDoc(
    FirebaseFirestore firestore,
    String orgId,
    Map<String, dynamic> payload,
    String collection,
    String entityId,
  ) {
    final profileId = _string(payload['profileId']);
    if (profileId.isEmpty) {
      return null;
    }
    return firestore
        .collection('orgs')
        .doc(orgId)
        .collection('pricingProfiles')
        .doc(profileId)
        .collection(collection)
        .doc(entityId);
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

  void _notifyDebug() {
    _debugTick.value += 1;
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes >= 1) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}s';
  }

  String _formatLocalTime(DateTime time) {
    final local = time.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    final ss = local.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}

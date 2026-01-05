import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'metrics_collector.dart';

class PresenceService with WidgetsBindingObserver {
  PresenceService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    SharedPreferences? preferences,
    Uuid? uuid,
    MetricsCollector? metricsCollector,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _preferences = preferences,
        _uuid = uuid ?? const Uuid(),
        _metricsCollector = metricsCollector ?? const NoopMetricsCollector();

  static const Duration freshnessWindow = Duration(minutes: 2);
  static const Duration heartbeatInterval = Duration(seconds: 45);
  static const String _deviceIdKey = 'presence_device_id';

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final SharedPreferences? _preferences;
  final Uuid _uuid;
  final MetricsCollector _metricsCollector;

  final _peerController = StreamController<bool>.broadcast();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _presenceSub;
  Timer? _heartbeatTimer;

  String? _orgId;
  String? _deviceId;
  bool _canBeOnline = false;
  bool _isForeground = true;
  bool _hasPeerOnline = false;

  bool get hasPeerOnline => _hasPeerOnline;
  Stream<bool> get hasPeerOnlineStream => _peerController.stream;

  Future<void> start() async {
    WidgetsBinding.instance.addObserver(this);
    _deviceId ??= await _loadDeviceId();
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _presenceSub?.cancel();
    _heartbeatTimer?.cancel();
    await _peerController.close();
  }

  void updateSession({required String? orgId, required bool canBeOnline}) {
    final orgChanged = orgId != _orgId;
    _orgId = orgId;
    _canBeOnline = canBeOnline;
    if (orgChanged) {
      _presenceSub?.cancel();
      _presenceSub = null;
      _hasPeerOnline = false;
      _peerController.add(false);
    }
    _applyPresenceState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    _applyPresenceState();
  }

  Future<String> _loadDeviceId() async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final created = _uuid.v4();
    await prefs.setString(_deviceIdKey, created);
    return created;
  }

  void _applyPresenceState() {
    final shouldBeOnline =
        _canBeOnline && _isForeground && _orgId != null && _deviceId != null;
    if (!shouldBeOnline) {
      _stopHeartbeat();
      _stopPresenceListener();
      unawaited(_markOffline());
      return;
    }
    _startPresenceListener();
    unawaited(_markOnline());
    _startHeartbeat();
  }

  void _startPresenceListener() {
    if (_presenceSub != null || _orgId == null) {
      return;
    }
    _presenceSub = _firestore
        .collection('orgs')
        .doc(_orgId)
        .collection('presence_devices')
        .where('online', isEqualTo: true)
        .snapshots()
        .listen(_handlePresenceSnapshot, onError: (_) {
      _setHasPeerOnline(false);
    });
  }

  void _stopPresenceListener() {
    _presenceSub?.cancel();
    _presenceSub = null;
    _setHasPeerOnline(false);
  }

  void _startHeartbeat() {
    _heartbeatTimer ??= Timer.periodic(heartbeatInterval, (_) {
      unawaited(_markOnline(updateOnly: true));
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> _markOnline({bool updateOnly = false}) async {
    if (_orgId == null || _deviceId == null) {
      return;
    }
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }
    final data = <String, dynamic>{
      'uid': user.uid,
      'online': true,
      'lastSeen': FieldValue.serverTimestamp(),
      'platform': _platformLabel(),
    };
    if (updateOnly) {
      data.remove('uid');
      data.remove('platform');
    }
    await _firestore
        .collection('orgs')
        .doc(_orgId)
        .collection('presence_devices')
        .doc(_deviceId)
        .set(data, SetOptions(merge: true));
    unawaited(_metricsCollector.recordWrite());
  }

  Future<void> _markOffline() async {
    if (_orgId == null || _deviceId == null) {
      return;
    }
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }
    await _firestore
        .collection('orgs')
        .doc(_orgId)
        .collection('presence_devices')
        .doc(_deviceId)
        .set(
      {
        'uid': user.uid,
        'online': false,
        'lastSeen': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    unawaited(_metricsCollector.recordWrite());
  }

  void _handlePresenceSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    unawaited(_metricsCollector.recordRead(count: snapshot.docs.length));
    final now = DateTime.now();
    final cutoff = now.subtract(freshnessWindow);
    final deviceId = _deviceId;
    final hasPeer = snapshot.docs.any((doc) {
      if (doc.id == deviceId) {
        return false;
      }
      final data = doc.data();
      final lastSeen = data['lastSeen'];
      if (lastSeen is! Timestamp) {
        return false;
      }
      return lastSeen.toDate().isAfter(cutoff);
    });
    _setHasPeerOnline(hasPeer);
  }

  void _setHasPeerOnline(bool value) {
    if (_hasPeerOnline == value || _peerController.isClosed) {
      return;
    }
    _hasPeerOnline = value;
    _peerController.add(value);
  }

  String _platformLabel() {
    if (kIsWeb) {
      return 'web';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }
}

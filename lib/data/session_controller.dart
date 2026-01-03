import 'dart:async';

import 'package:flutter/foundation.dart';

class AppSession {
  const AppSession({
    required this.orgId,
    required this.userId,
    required this.isGuest,
  });

  final String orgId;
  final String? userId;
  final bool isGuest;
}

class SessionController extends ValueNotifier<AppSession?> {
  SessionController() : super(null);

  bool get isReady => value != null;
  AppSession get session => value!;
  final StreamController<AppSession?> _streamController =
      StreamController<AppSession?>.broadcast();

  Stream<AppSession?> get stream => _streamController.stream;

  void setGuest({required String orgId}) {
    value = AppSession(orgId: orgId, userId: null, isGuest: true);
    _streamController.add(value);
  }

  void setAuthenticated({required String orgId, required String userId}) {
    value = AppSession(orgId: orgId, userId: userId, isGuest: false);
    _streamController.add(value);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';

class AppSession {
  const AppSession({
    required this.orgId,
    required this.userId,
    required this.isGuest,
    required this.role,
    required this.email,
  });

  final String? orgId;
  final String? userId;
  final bool isGuest;
  final String? role;
  final String? email;

  bool get hasOrg => orgId != null;
}

class SessionController extends ValueNotifier<AppSession?> {
  SessionController() : super(null);

  bool get isReady => value != null;
  AppSession get session => value!;
  final StreamController<AppSession?> _streamController =
      StreamController<AppSession?>.broadcast();

  Stream<AppSession?> get stream => _streamController.stream;

  void setGuest({required String orgId}) {
    value = AppSession(
      orgId: orgId,
      userId: null,
      isGuest: true,
      role: null,
      email: null,
    );
    _streamController.add(value);
  }

  void setAuthenticated({
    required String orgId,
    required String userId,
    required String? role,
    required String? email,
  }) {
    value = AppSession(
      orgId: orgId,
      userId: userId,
      isGuest: false,
      role: role,
      email: email,
    );
    _streamController.add(value);
  }

  void setAuthenticatedWithoutOrg({
    required String userId,
    required String? email,
  }) {
    value = AppSession(
      orgId: null,
      userId: userId,
      isGuest: false,
      role: null,
      email: email,
    );
    _streamController.add(value);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

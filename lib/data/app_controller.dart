import 'package:firebase_auth/firebase_auth.dart';

import 'local_db.dart';
import 'session_controller.dart';
import 'sync_service.dart';

class AppController {
  AppController({
    required AppDatabase db,
    required SessionController sessionController,
    required SyncService syncService,
  })  : _db = db,
        _sessionController = sessionController,
        _syncService = syncService;

  final AppDatabase _db;
  final SessionController _sessionController;
  final SyncService _syncService;

  static const guestOrgId = 'guest-org';

  Future<void> continueOffline() async {
    _sessionController.setGuest(orgId: guestOrgId);
  }

  Future<void> signInWithEmail(String email, String password) async {
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      await _handleUser(user);
    }
  }

  Future<void> useExistingUser(User user) async {
    await _handleUser(user);
  }

  Future<void> _handleUser(User user) async {
    final previousOrgId =
        _sessionController.value?.orgId ?? AppController.guestOrgId;
    if (previousOrgId != user.uid) {
      await _db.migrateOrg(previousOrgId, user.uid);
    }
    _sessionController.setAuthenticated(orgId: user.uid, userId: user.uid);
    await _syncService.sync();
  }
}

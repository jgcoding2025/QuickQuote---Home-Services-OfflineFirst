import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import 'local_db.dart';
import 'session_controller.dart';
import 'sync_service.dart';

// Firestore security rules snippet (paste into Firebase rules as needed):
// match /orgs/{orgId}/clients/{clientId} {
//   allow read, write: if exists(/databases/$(database)/documents/orgs/$(orgId)/members/$(request.auth.uid));
// }
// match /orgs/{orgId}/quotes/{quoteId} {
//   allow read, write: if exists(/databases/$(database)/documents/orgs/$(orgId)/members/$(request.auth.uid));
// }
// match /users/{uid} { allow read, write: if request.auth.uid == uid; }
// match /invites/{inviteCode} {
//   allow create: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'owner'
//     && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.orgId == request.resource.data.orgId;
//   allow read, update: if request.auth != null && resource.data.active == true;
// }

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
  static const demoOrgId = 'demo-org';
  static const _defaultInviteRole = 'member';

  Future<void> continueOffline() async {
    final orgId = _sessionController.value?.orgId ?? guestOrgId;
    _sessionController.setGuest(orgId: orgId);
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

  Future<void> createAccount(String email, String password) async {
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

  Future<void> signOut() async {
    final orgId = _sessionController.value?.orgId ?? guestOrgId;
    await FirebaseAuth.instance.signOut();
    _sessionController.setGuest(orgId: orgId);
  }

  Future<void> createOrganization({required String name}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not signed in.');
    }
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw StateError('Organization name is required.');
    }
    final orgId = const Uuid().v4();
    final email = user.email ?? '';
    final now = FieldValue.serverTimestamp();
    final orgRef =
        FirebaseFirestore.instance.collection('orgs').doc(orgId);
    final memberRef = orgRef.collection('members').doc(user.uid);
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final batch = FirebaseFirestore.instance.batch();
    batch.set(orgRef, {
      'name': trimmedName,
      'ownerUid': user.uid,
      'createdAt': now,
      'updatedAt': now,
    });
    batch.set(memberRef, {
      'role': 'owner',
      'email': email,
      'createdAt': now,
    });
    batch.set(
      userRef,
      {
        'email': email,
        'createdAt': now,
        'orgId': orgId,
        'role': 'owner',
      },
      SetOptions(merge: true),
    );
    await batch.commit();
    await _activateOrg(orgId: orgId, role: 'owner', user: user);
  }

  Future<void> joinWithInviteCode(String inviteCode) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not signed in.');
    }
    final code = inviteCode.trim().toUpperCase();
    final inviteRef =
        FirebaseFirestore.instance.collection('invites').doc(code);
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final email = user.email ?? '';
    late String orgId;
    late String role;
    await FirebaseFirestore.instance.runTransaction((txn) async {
      final inviteSnap = await txn.get(inviteRef);
      if (!inviteSnap.exists) {
        throw StateError('Invite code not found.');
      }
      final data = inviteSnap.data() ?? {};
      final isActive = data['active'] == true;
      final usedBy = data['usedByUid'];
      if (!isActive || usedBy != null) {
        throw StateError('Invite code is no longer active.');
      }
      orgId = (data['orgId'] as String?) ?? '';
      if (orgId.isEmpty) {
        throw StateError('Invite is missing an organization.');
      }
      role = (data['role'] as String?) ?? _defaultInviteRole;
      final memberRef = FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgId)
          .collection('members')
          .doc(user.uid);
      txn.update(inviteRef, {
        'active': false,
        'usedByUid': user.uid,
        'usedAt': FieldValue.serverTimestamp(),
      });
      txn.set(memberRef, {
        'role': role,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      txn.set(
        userRef,
        {
          'email': email,
          'orgId': orgId,
          'role': role,
        },
        SetOptions(merge: true),
      );
    });
    await _activateOrg(orgId: orgId, role: role, user: user);
  }

  Future<bool> canClaimDemoOrg() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (userDoc.data()?['orgId'] != null) {
      return false;
    }
    final orgDoc =
        await FirebaseFirestore.instance.collection('orgs').doc(demoOrgId).get();
    if (!orgDoc.exists) {
      return false;
    }
    final membersSnap = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(demoOrgId)
        .collection('members')
        .limit(1)
        .get();
    return membersSnap.docs.isEmpty;
  }

  Future<void> claimDemoOrg() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not signed in.');
    }
    final orgDoc = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(demoOrgId)
        .get();
    if (!orgDoc.exists) {
      throw StateError('Demo org does not exist.');
    }
    final membersSnap = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(demoOrgId)
        .collection('members')
        .limit(1)
        .get();
    if (membersSnap.docs.isNotEmpty) {
      throw StateError('Demo org has already been claimed.');
    }
    final now = FieldValue.serverTimestamp();
    final email = user.email ?? '';
    final memberRef = FirebaseFirestore.instance
        .collection('orgs')
        .doc(demoOrgId)
        .collection('members')
        .doc(user.uid);
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final batch = FirebaseFirestore.instance.batch();
    batch.set(memberRef, {
      'role': 'owner',
      'email': email,
      'createdAt': now,
    });
    batch.set(
      userRef,
      {
        'email': email,
        'orgId': demoOrgId,
        'role': 'owner',
      },
      SetOptions(merge: true),
    );
    await batch.commit();
    await _activateOrg(orgId: demoOrgId, role: 'owner', user: user);
  }

  Future<String> createInviteCode() async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    final userId = session.userId;
    if (session.role != 'owner' || orgId == null || userId == null) {
      throw StateError('Only org owners can create invites.');
    }
    final code = await _generateUniqueInviteCode();
    await FirebaseFirestore.instance.collection('invites').doc(code).set({
      'orgId': orgId,
      'role': _defaultInviteRole,
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
      'createdByUid': userId,
      'usedByUid': null,
      'usedAt': null,
    });
    return code;
  }

  Future<void> _handleUser(User user) async {
    final profile = await _loadUserProfile(user);
    if (profile.orgId != null) {
      await _activateOrg(
        orgId: profile.orgId!,
        role: profile.role ?? _defaultInviteRole,
        user: user,
      );
      return;
    }
    await _ensureUserProfileExists(user, profile: profile);
    _sessionController.setAuthenticatedWithoutOrg(
      userId: user.uid,
      email: user.email,
    );
  }

  Future<void> _activateOrg({
    required String orgId,
    required String role,
    required User user,
  }) async {
    final previousSession = _sessionController.value;
    if (previousSession != null &&
        previousSession.isGuest &&
        previousSession.orgId == guestOrgId &&
        orgId != guestOrgId) {
      await _db.migrateOrg(guestOrgId, orgId);
    }
    _sessionController.setAuthenticated(
      orgId: orgId,
      userId: user.uid,
      role: role,
      email: user.email,
    );
    await _syncService.runOnce();
  }

  Future<_UserProfile> _loadUserProfile(User user) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      return _UserProfile.missing(email: user.email);
    }
    final data = doc.data() ?? {};
    return _UserProfile(
      orgId: data['orgId'] as String?,
      role: data['role'] as String?,
      email: data['email'] as String? ?? user.email,
      exists: true,
    );
  }

  Future<void> _ensureUserProfileExists(
    User user, {
    required _UserProfile profile,
  }) async {
    if (profile.exists) {
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'email': user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<String> _generateUniqueInviteCode() async {
    final characters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    for (var attempt = 0; attempt < 5; attempt++) {
      final code = _randomCode(characters, length: 8);
      final existing = await FirebaseFirestore.instance
          .collection('invites')
          .doc(code)
          .get();
      if (!existing.exists) {
        return code;
      }
    }
    throw StateError('Failed to generate a unique invite code.');
  }

  String _randomCode(String alphabet, {required int length}) {
    final uuid = const Uuid();
    final buffer = StringBuffer();
    while (buffer.length < length) {
      final bytes = uuid.v4obj().bytes;
      for (final byte in bytes) {
        buffer.write(alphabet[byte % alphabet.length]);
        if (buffer.length >= length) {
          break;
        }
      }
    }
    return buffer.toString();
  }
}

class _UserProfile {
  const _UserProfile({
    required this.orgId,
    required this.role,
    required this.email,
    required this.exists,
  });

  factory _UserProfile.missing({required String? email}) {
    return _UserProfile(orgId: null, role: null, email: email, exists: false);
  }

  final String? orgId;
  final String? role;
  final String? email;
  final bool exists;
}

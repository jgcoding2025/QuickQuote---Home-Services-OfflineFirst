import 'package:cloud_firestore/cloud_firestore.dart';

import 'org_settings_models.dart';

class OrgSettingsRepo {
  OrgSettingsRepo({required this.orgId});
  final String orgId;

  DocumentReference<Map<String, dynamic>> get _doc => FirebaseFirestore.instance
      .collection('orgs')
      .doc(orgId)
      .collection('settings')
      .doc('defaults');

  Stream<OrgSettings> stream() {
    return _doc.snapshots(includeMetadataChanges: true).map((snap) {
      return OrgSettings.fromMap(snap.data());
    });
  }

  Future<void> save(OrgSettings settings) async {
    await _doc.set(
      settings.toMap(updatedAt: DateTime.now().millisecondsSinceEpoch),
      SetOptions(merge: true),
    );
  }
}

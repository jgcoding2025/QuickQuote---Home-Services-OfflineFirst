import 'package:cloud_firestore/cloud_firestore.dart';

class OrgSettings {
  final double laborRate;
  final bool taxEnabled;
  final double taxRate;
  final bool ccEnabled;
  final double ccRate;

  const OrgSettings({
    required this.laborRate,
    required this.taxEnabled,
    required this.taxRate,
    required this.ccEnabled,
    required this.ccRate,
  });

  static const defaults = OrgSettings(
    laborRate: 40.0,
    taxEnabled: false,
    taxRate: 0.07,
    ccEnabled: false,
    ccRate: 0.03,
  );

  Map<String, dynamic> toMap() => {
    'laborRate': laborRate,
    'taxEnabled': taxEnabled,
    'taxRate': taxRate,
    'ccEnabled': ccEnabled,
    'ccRate': ccRate,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  factory OrgSettings.fromMap(Map<String, dynamic>? data) {
    final d = data ?? const <String, dynamic>{};
    double numD(String k, double fallback) {
      final v = d[k];
      if (v is num) return v.toDouble();
      return fallback;
    }

    bool boolD(String k, bool fallback) {
      final v = d[k];
      if (v is bool) return v;
      return fallback;
    }

    return OrgSettings(
      laborRate: numD('laborRate', defaults.laborRate),
      taxEnabled: boolD('taxEnabled', defaults.taxEnabled),
      taxRate: numD('taxRate', defaults.taxRate),
      ccEnabled: boolD('ccEnabled', defaults.ccEnabled),
      ccRate: numD('ccRate', defaults.ccRate),
    );
  }
}

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
    await _doc.set(settings.toMap(), SetOptions(merge: true));
  }
}

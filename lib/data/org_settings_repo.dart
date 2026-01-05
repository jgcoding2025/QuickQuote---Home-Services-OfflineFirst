import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'org_settings_models.dart';
import 'metrics_collector.dart';

class OrgSettingsRepo {
  OrgSettingsRepo({required this.orgId, MetricsCollector? metricsCollector})
      : _metricsCollector = metricsCollector ?? const NoopMetricsCollector();
  final String orgId;
  final MetricsCollector _metricsCollector;

  DocumentReference<Map<String, dynamic>> get _doc => FirebaseFirestore.instance
      .collection('orgs')
      .doc(orgId)
      .collection('settings')
      .doc('defaults');

  Stream<OrgSettings> stream() {
    return _doc.snapshots(includeMetadataChanges: true).map((snap) {
      unawaited(_metricsCollector.recordRead());
      return OrgSettings.fromMap(snap.data());
    });
  }

  Future<void> save(OrgSettings settings) async {
    await _doc.set(
      settings.toMap(updatedAt: DateTime.now().millisecondsSinceEpoch),
      SetOptions(merge: true),
    );
    unawaited(_metricsCollector.recordWrite());
  }
}

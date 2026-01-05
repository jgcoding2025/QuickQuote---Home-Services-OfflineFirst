import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'client_models.dart';
import 'metrics_collector.dart';

class ClientsRepo {
  ClientsRepo({required this.orgId, MetricsCollector? metricsCollector})
      : _metricsCollector = metricsCollector ?? const NoopMetricsCollector();
  final String orgId;
  final MetricsCollector _metricsCollector;

  String newClientId() => _col.doc().id;

  Future<void> setClient(
    String clientId,
    ClientDraft d, {
    required bool isNew,
  }) async {
    final data = <String, dynamic>{
      ...d.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (isNew) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await _col.doc(clientId).set(data, SetOptions(merge: true));
    unawaited(_metricsCollector.recordWrite());
  }

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('orgs')
      .doc(orgId)
      .collection('clients');

  Stream<List<Client>> streamClients() {
    return _col.orderBy('lastName').snapshots().map((snap) {
      unawaited(_metricsCollector.recordRead(count: snap.docs.length));
      return snap.docs.map((d) => _clientFromDoc(d)).toList();
    });
  }

  Future<void> deleteClient(String clientId) async {
    await _col.doc(clientId).delete();
    unawaited(_metricsCollector.recordWrite());
  }

  Future<void> restoreClient(String clientId, ClientDraft draft) async {
    await setClient(clientId, draft, isNew: true);
  }

  Client _clientFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    String s(String k) => (data[k] ?? '') as String;
    return Client(
      id: doc.id,
      firstName: s('firstName'),
      lastName: s('lastName'),
      street1: s('street1'),
      street2: s('street2'),
      city: s('city'),
      state: s('state'),
      zip: s('zip'),
      phone: s('phone'),
      email: s('email'),
      notes: s('notes'),
    );
  }
}

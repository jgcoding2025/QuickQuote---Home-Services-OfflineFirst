import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'quote_models.dart';
import 'metrics_collector.dart';

class QuotesRepo {
  QuotesRepo({required this.orgId, MetricsCollector? metricsCollector})
      : _metricsCollector = metricsCollector ?? const NoopMetricsCollector();
  final String orgId;
  final MetricsCollector _metricsCollector;

  String newQuoteId() => _col.doc().id;

  Future<void> setQuote(
    String quoteId,
    QuoteDraft d, {
    required bool isNew,
  }) async {
    final data = <String, dynamic>{
      ...d.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (isNew) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await _col.doc(quoteId).set(data, SetOptions(merge: true));
    unawaited(_metricsCollector.recordWrite());
  }

  Future<Quote> createQuote(QuoteDraft d) async {
    final id = newQuoteId();
    final data = <String, dynamic>{
      ...d.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _col.doc(id).set(data, SetOptions(merge: true));
    unawaited(_metricsCollector.recordWrite());

    return Quote(
      id: id,
      clientId: d.clientId,
      clientName: d.clientName,
      quoteName: d.quoteName,
      quoteDate: d.quoteDate,
      serviceType: d.serviceType,
      frequency: d.frequency,
      lastProClean: d.lastProClean,
      status: d.status,
      total: d.total,
      pricingProfileId: d.pricingProfileId,
    );
  }

  Future<void> updateQuote(String quoteId, QuoteDraft d) async {
    final docRef = _col.doc(quoteId);
    final data = <String, dynamic>{
      ...d.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final snapshot = await docRef.get();
    unawaited(_metricsCollector.recordRead());
    if (snapshot.exists) {
      await docRef.set(data, SetOptions(merge: true));
      unawaited(_metricsCollector.recordWrite());
      return;
    }
    await docRef.set(
      {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    unawaited(_metricsCollector.recordWrite());
  }

  Future<void> restoreQuote(String quoteId, QuoteDraft d) async {
    final data = <String, dynamic>{
      ...d.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _col.doc(quoteId).set(data, SetOptions(merge: true));
    unawaited(_metricsCollector.recordWrite());
  }

  Future<void> deleteQuote(String quoteId) async {
    await _col.doc(quoteId).delete();
    unawaited(_metricsCollector.recordWrite());
  }

  Stream<List<Quote>> streamQuotes() {
    return _col.orderBy('createdAt', descending: true).snapshots().map((snap) {
      unawaited(_metricsCollector.recordRead(count: snap.docs.length));
      return snap.docs.map((d) => _quoteFromDoc(d)).toList();
    });
  }

  Stream<List<Quote>> streamQuotesForClient(String clientId) {
    return _col
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      unawaited(_metricsCollector.recordRead(count: snap.docs.length));
      return snap.docs.map((d) => _quoteFromDoc(d)).toList();
    });
  }

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('orgs')
      .doc(orgId)
      .collection('quotes');

  Quote _quoteFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    String s(String k) => (data[k] ?? '') as String;
    double n(String k, {double fallback = 0}) {
      final value = data[k];
      if (value == null) {
        return fallback;
      }
      if (value is num) {
        return value.toDouble();
      }
      return double.tryParse(value.toString()) ?? fallback;
    }
    bool b(String k, {bool fallback = false}) {
      final value = data[k];
      if (value is bool) {
        return value;
      }
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
      return fallback;
    }
    final rawItems = data['items'];
    final items = rawItems is List
        ? rawItems.whereType<Map<String, dynamic>>().toList()
        : <Map<String, dynamic>>[];
    final rawPets = data['pets'];
    final pets = rawPets is List
        ? rawPets.whereType<Map<String, dynamic>>().toList()
        : <Map<String, dynamic>>[];
    final rawMembers = data['householdMembers'];
    final members = rawMembers is List
        ? rawMembers.whereType<Map<String, dynamic>>().toList()
        : <Map<String, dynamic>>[];

    return Quote(
      id: doc.id,
      clientId: s('clientId'),
      clientName: s('clientName'),
      quoteName: s('quoteName'),
      quoteDate: s('quoteDate'),
      serviceType: s('serviceType'),
      frequency: s('frequency'),
      lastProClean: s('lastProClean'),
      status: s('status').isEmpty ? 'Draft' : s('status'),
      total: n('total'),
      address: s('address'),
      totalSqFt: s('totalSqFt'),
      useTotalSqFt: b('useTotalSqFt', fallback: true),
      estimatedSqFt: s('estimatedSqFt'),
      petsPresent: b('petsPresent'),
      homeOccupied: b('homeOccupied', fallback: true),
      entryCode: s('entryCode'),
      paymentMethod: s('paymentMethod'),
      feedbackDiscussed: b('feedbackDiscussed'),
      laborRate: n('laborRate', fallback: 40.0),
      taxEnabled: b('taxEnabled'),
      ccEnabled: b('ccEnabled'),
      taxRate: n('taxRate', fallback: 0.07),
      ccRate: n('ccRate', fallback: 0.03),
      pricingProfileId:
          s('pricingProfileId').isEmpty ? 'default' : s('pricingProfileId'),
      defaultRoomType: s('defaultRoomType'),
      defaultLevel: s('defaultLevel'),
      defaultSize: s('defaultSize'),
      defaultComplexity: s('defaultComplexity'),
      subItemType: s('subItemType'),
      specialNotes: s('specialNotes'),
      items: items,
      pets: pets.map(Pet.fromMap).toList(),
      householdMembers: members.map(HouseholdMember.fromMap).toList(),
    );
  }
}

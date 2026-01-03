import 'package:cloud_firestore/cloud_firestore.dart';

class QuotesRepo {
  QuotesRepo({required this.orgId});
  final String orgId;

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
  }

  Future<Quote> createQuote(QuoteDraft d) async {
    final id = newQuoteId();
    final data = <String, dynamic>{
      ...d.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _col.doc(id).set(data, SetOptions(merge: true));

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
    );
  }

  Future<void> updateQuote(String quoteId, QuoteDraft d) async {
    final docRef = _col.doc(quoteId);
    final data = <String, dynamic>{
      ...d.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      await docRef.set(data, SetOptions(merge: true));
      return;
    }
    await docRef.set(
      {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> restoreQuote(String quoteId, QuoteDraft d) async {
    final data = <String, dynamic>{
      ...d.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _col.doc(quoteId).set(data, SetOptions(merge: true));
  }

  Future<void> deleteQuote(String quoteId) async {
    await _col.doc(quoteId).delete();
  }

  Stream<List<Quote>> streamQuotes() {
    return _col.orderBy('createdAt', descending: true).snapshots().map((snap) {
      return snap.docs.map((d) => Quote.fromDoc(d)).toList();
    });
  }

  Stream<List<Quote>> streamQuotesForClient(String clientId) {
    return _col
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Quote.fromDoc(d)).toList());
  }

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('orgs')
      .doc(orgId)
      .collection('quotes');
}

class Quote {
  Quote({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.quoteName,
    required this.quoteDate,
    required this.serviceType,
    required this.frequency,
    required this.lastProClean,
    required this.status,
    required this.total,
    this.address = '',
    this.totalSqFt = '',
    this.useTotalSqFt = true,
    this.estimatedSqFt = '',
    this.petsPresent = false,
    this.homeOccupied = true,
    this.entryCode = '',
    this.paymentMethod = '',
    this.feedbackDiscussed = false,
    this.laborRate = 40.0,
    this.taxEnabled = false,
    this.ccEnabled = false,
    this.taxRate = 0.07,
    this.ccRate = 0.03,
    this.defaultRoomType = '',
    this.defaultLevel = '',
    this.defaultSize = '',
    this.defaultComplexity = '',
    this.subItemType = '',
    this.specialNotes = '',
    this.items = const [],
  });

  final String id;
  final String clientId;
  final String clientName;
  final String quoteName;
  final String quoteDate;
  final String serviceType;
  final String frequency;
  final String lastProClean;
  final String status;
  final double total;
  final String address;
  final String totalSqFt;
  final bool useTotalSqFt;
  final String estimatedSqFt;
  final bool petsPresent;
  final bool homeOccupied;
  final String entryCode;
  final String paymentMethod;
  final bool feedbackDiscussed;
  final double laborRate;
  final bool taxEnabled;
  final bool ccEnabled;
  final double taxRate;
  final double ccRate;
  final String defaultRoomType;
  final String defaultLevel;
  final String defaultSize;
  final String defaultComplexity;
  final String subItemType;
  final String specialNotes;
  final List<Map<String, dynamic>> items;

  factory Quote.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
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
      defaultRoomType: s('defaultRoomType'),
      defaultLevel: s('defaultLevel'),
      defaultSize: s('defaultSize'),
      defaultComplexity: s('defaultComplexity'),
      subItemType: s('subItemType'),
      specialNotes: s('specialNotes'),
      items: items,
    );
  }
}

class QuoteDraft {
  QuoteDraft({
    required this.clientId,
    required this.clientName,
    required this.quoteName,
    required this.quoteDate,
    required this.serviceType,
    required this.frequency,
    required this.lastProClean,
    required this.status,
    required this.total,
    this.address = '',
    this.totalSqFt = '',
    this.useTotalSqFt = true,
    this.estimatedSqFt = '',
    this.petsPresent = false,
    this.homeOccupied = true,
    this.entryCode = '',
    this.paymentMethod = '',
    this.feedbackDiscussed = false,
    this.laborRate = 40.0,
    this.taxEnabled = false,
    this.ccEnabled = false,
    this.taxRate = 0.07,
    this.ccRate = 0.03,
    this.defaultRoomType = '',
    this.defaultLevel = '',
    this.defaultSize = '',
    this.defaultComplexity = '',
    this.subItemType = '',
    this.specialNotes = '',
    this.items = const [],
  });

  final String clientId;
  final String clientName;
  final String quoteName;
  final String quoteDate;
  final String serviceType;
  final String frequency;
  final String lastProClean;
  final String status;
  final double total;
  final String address;
  final String totalSqFt;
  final bool useTotalSqFt;
  final String estimatedSqFt;
  final bool petsPresent;
  final bool homeOccupied;
  final String entryCode;
  final String paymentMethod;
  final bool feedbackDiscussed;
  final double laborRate;
  final bool taxEnabled;
  final bool ccEnabled;
  final double taxRate;
  final double ccRate;
  final String defaultRoomType;
  final String defaultLevel;
  final String defaultSize;
  final String defaultComplexity;
  final String subItemType;
  final String specialNotes;
  final List<Map<String, dynamic>> items;

  Map<String, dynamic> toMap() => {
    'clientId': clientId.trim(),
    'clientName': clientName.trim(),
    'quoteName': quoteName.trim(),
    'quoteDate': quoteDate.trim(),
    'serviceType': serviceType.trim(),
    'frequency': frequency.trim(),
    'lastProClean': lastProClean.trim(),
    'status': status.trim(),
    'total': total,
    'address': address.trim(),
    'totalSqFt': totalSqFt.trim(),
    'useTotalSqFt': useTotalSqFt,
    'estimatedSqFt': estimatedSqFt.trim(),
    'petsPresent': petsPresent,
    'homeOccupied': homeOccupied,
    'entryCode': entryCode.trim(),
    'paymentMethod': paymentMethod.trim(),
    'feedbackDiscussed': feedbackDiscussed,
    'laborRate': laborRate,
    'taxEnabled': taxEnabled,
    'ccEnabled': ccEnabled,
    'taxRate': taxRate,
    'ccRate': ccRate,
    'defaultRoomType': defaultRoomType.trim(),
    'defaultLevel': defaultLevel.trim(),
    'defaultSize': defaultSize.trim(),
    'defaultComplexity': defaultComplexity.trim(),
    'subItemType': subItemType.trim(),
    'specialNotes': specialNotes.trim(),
    'items': items,
  };
}

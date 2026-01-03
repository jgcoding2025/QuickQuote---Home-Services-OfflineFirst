import 'package:cloud_firestore/cloud_firestore.dart';

class ClientsRepo {
  ClientsRepo({required this.orgId});
  final String orgId;

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
  }

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('orgs')
      .doc(orgId)
      .collection('clients');

  Stream<List<Client>> streamClients() {
    return _col.orderBy('lastName').snapshots().map((snap) {
      return snap.docs.map((d) => Client.fromDoc(d)).toList();
    });
  }

  Future<void> deleteClient(String clientId) async {
    await _col.doc(clientId).delete();
  }

  Future<void> restoreClient(String clientId, ClientDraft draft) async {
    await setClient(clientId, draft, isNew: true);
  }
}

class Client {
  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.street1,
    required this.street2,
    required this.city,
    required this.state,
    required this.zip,
    required this.phone,
    required this.email,
    required this.notes,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String street1;
  final String street2;
  final String city;
  final String state;
  final String zip;
  final String phone;
  final String email;
  final String notes;

  String get displayName {
    final n = ('$firstName $lastName').trim();
    return n.isEmpty ? '(Unnamed Client)' : n;
  }

  factory Client.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
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

  ClientDraft toDraft() => ClientDraft(
    firstName: firstName,
    lastName: lastName,
    street1: street1,
    street2: street2,
    city: city,
    state: state,
    zip: zip,
    phone: phone,
    email: email,
    notes: notes,
  );
}

class ClientDraft {
  ClientDraft({
    this.firstName = '',
    this.lastName = '',
    this.street1 = '',
    this.street2 = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.phone = '',
    this.email = '',
    this.notes = '',
  });

  String firstName,
      lastName,
      street1,
      street2,
      city,
      state,
      zip,
      phone,
      email,
      notes;

  Map<String, dynamic> toMap() => {
    'firstName': firstName.trim(),
    'lastName': lastName.trim(),
    'street1': street1.trim(),
    'street2': street2.trim(),
    'city': city.trim(),
    'state': state.trim(),
    'zip': zip.trim(),
    'phone': phone.trim(),
    'email': email.trim(),
    'notes': notes.trim(),
  };
}

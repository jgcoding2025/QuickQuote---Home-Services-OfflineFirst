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

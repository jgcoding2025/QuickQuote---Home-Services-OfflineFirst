// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_db.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, ClientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _street1Meta = const VerificationMeta(
    'street1',
  );
  @override
  late final GeneratedColumn<String> street1 = GeneratedColumn<String>(
    'street1',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _street2Meta = const VerificationMeta(
    'street2',
  );
  @override
  late final GeneratedColumn<String> street2 = GeneratedColumn<String>(
    'street2',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _zipMeta = const VerificationMeta('zip');
  @override
  late final GeneratedColumn<String> zip = GeneratedColumn<String>(
    'zip',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    updatedAt,
    deleted,
    firstName,
    lastName,
    street1,
    street2,
    city,
    state,
    zip,
    phone,
    email,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('street1')) {
      context.handle(
        _street1Meta,
        street1.isAcceptableOrUnknown(data['street1']!, _street1Meta),
      );
    }
    if (data.containsKey('street2')) {
      context.handle(
        _street2Meta,
        street2.isAcceptableOrUnknown(data['street2']!, _street2Meta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('zip')) {
      context.handle(
        _zipMeta,
        zip.isAcceptableOrUnknown(data['zip']!, _zipMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      street1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}street1'],
      )!,
      street2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}street2'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      zip: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zip'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class ClientRow extends DataClass implements Insertable<ClientRow> {
  final String id;
  final String orgId;
  final int updatedAt;
  final bool deleted;
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
  const ClientRow({
    required this.id,
    required this.orgId,
    required this.updatedAt,
    required this.deleted,
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['street1'] = Variable<String>(street1);
    map['street2'] = Variable<String>(street2);
    map['city'] = Variable<String>(city);
    map['state'] = Variable<String>(state);
    map['zip'] = Variable<String>(zip);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      orgId: Value(orgId),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      firstName: Value(firstName),
      lastName: Value(lastName),
      street1: Value(street1),
      street2: Value(street2),
      city: Value(city),
      state: Value(state),
      zip: Value(zip),
      phone: Value(phone),
      email: Value(email),
      notes: Value(notes),
    );
  }

  factory ClientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      street1: serializer.fromJson<String>(json['street1']),
      street2: serializer.fromJson<String>(json['street2']),
      city: serializer.fromJson<String>(json['city']),
      state: serializer.fromJson<String>(json['state']),
      zip: serializer.fromJson<String>(json['zip']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'street1': serializer.toJson<String>(street1),
      'street2': serializer.toJson<String>(street2),
      'city': serializer.toJson<String>(city),
      'state': serializer.toJson<String>(state),
      'zip': serializer.toJson<String>(zip),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'notes': serializer.toJson<String>(notes),
    };
  }

  ClientRow copyWith({
    String? id,
    String? orgId,
    int? updatedAt,
    bool? deleted,
    String? firstName,
    String? lastName,
    String? street1,
    String? street2,
    String? city,
    String? state,
    String? zip,
    String? phone,
    String? email,
    String? notes,
  }) => ClientRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    street1: street1 ?? this.street1,
    street2: street2 ?? this.street2,
    city: city ?? this.city,
    state: state ?? this.state,
    zip: zip ?? this.zip,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    notes: notes ?? this.notes,
  );
  ClientRow copyWithCompanion(ClientsCompanion data) {
    return ClientRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      street1: data.street1.present ? data.street1.value : this.street1,
      street2: data.street2.present ? data.street2.value : this.street2,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      zip: data.zip.present ? data.zip.value : this.zip,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('street1: $street1, ')
          ..write('street2: $street2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('zip: $zip, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    updatedAt,
    deleted,
    firstName,
    lastName,
    street1,
    street2,
    city,
    state,
    zip,
    phone,
    email,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.street1 == this.street1 &&
          other.street2 == this.street2 &&
          other.city == this.city &&
          other.state == this.state &&
          other.zip == this.zip &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.notes == this.notes);
}

class ClientsCompanion extends UpdateCompanion<ClientRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> street1;
  final Value<String> street2;
  final Value<String> city;
  final Value<String> state;
  final Value<String> zip;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> notes;
  final Value<int> rowid;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.street1 = const Value.absent(),
    this.street2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.zip = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsCompanion.insert({
    required String id,
    required String orgId,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.street1 = const Value.absent(),
    this.street2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.zip = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       updatedAt = Value(updatedAt);
  static Insertable<ClientRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? street1,
    Expression<String>? street2,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? zip,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (street1 != null) 'street1': street1,
      if (street2 != null) 'street2': street2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (zip != null) 'zip': zip,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? street1,
    Value<String>? street2,
    Value<String>? city,
    Value<String>? state,
    Value<String>? zip,
    Value<String>? phone,
    Value<String>? email,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      street1: street1 ?? this.street1,
      street2: street2 ?? this.street2,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (street1.present) {
      map['street1'] = Variable<String>(street1.value);
    }
    if (street2.present) {
      map['street2'] = Variable<String>(street2.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (zip.present) {
      map['zip'] = Variable<String>(zip.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('street1: $street1, ')
          ..write('street2: $street2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('zip: $zip, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuotesTable extends Quotes with TableInfo<$QuotesTable, QuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clientNameMeta = const VerificationMeta(
    'clientName',
  );
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _quoteNameMeta = const VerificationMeta(
    'quoteName',
  );
  @override
  late final GeneratedColumn<String> quoteName = GeneratedColumn<String>(
    'quote_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _quoteDateMeta = const VerificationMeta(
    'quoteDate',
  );
  @override
  late final GeneratedColumn<String> quoteDate = GeneratedColumn<String>(
    'quote_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastProCleanMeta = const VerificationMeta(
    'lastProClean',
  );
  @override
  late final GeneratedColumn<String> lastProClean = GeneratedColumn<String>(
    'last_pro_clean',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Draft'),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _totalSqFtMeta = const VerificationMeta(
    'totalSqFt',
  );
  @override
  late final GeneratedColumn<String> totalSqFt = GeneratedColumn<String>(
    'total_sq_ft',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _useTotalSqFtMeta = const VerificationMeta(
    'useTotalSqFt',
  );
  @override
  late final GeneratedColumn<bool> useTotalSqFt = GeneratedColumn<bool>(
    'use_total_sq_ft',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_total_sq_ft" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _estimatedSqFtMeta = const VerificationMeta(
    'estimatedSqFt',
  );
  @override
  late final GeneratedColumn<String> estimatedSqFt = GeneratedColumn<String>(
    'estimated_sq_ft',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _petsPresentMeta = const VerificationMeta(
    'petsPresent',
  );
  @override
  late final GeneratedColumn<bool> petsPresent = GeneratedColumn<bool>(
    'pets_present',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pets_present" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _homeOccupiedMeta = const VerificationMeta(
    'homeOccupied',
  );
  @override
  late final GeneratedColumn<bool> homeOccupied = GeneratedColumn<bool>(
    'home_occupied',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_occupied" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _entryCodeMeta = const VerificationMeta(
    'entryCode',
  );
  @override
  late final GeneratedColumn<String> entryCode = GeneratedColumn<String>(
    'entry_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _feedbackDiscussedMeta = const VerificationMeta(
    'feedbackDiscussed',
  );
  @override
  late final GeneratedColumn<bool> feedbackDiscussed = GeneratedColumn<bool>(
    'feedback_discussed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("feedback_discussed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _laborRateMeta = const VerificationMeta(
    'laborRate',
  );
  @override
  late final GeneratedColumn<double> laborRate = GeneratedColumn<double>(
    'labor_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(40.0),
  );
  static const VerificationMeta _taxEnabledMeta = const VerificationMeta(
    'taxEnabled',
  );
  @override
  late final GeneratedColumn<bool> taxEnabled = GeneratedColumn<bool>(
    'tax_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tax_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ccEnabledMeta = const VerificationMeta(
    'ccEnabled',
  );
  @override
  late final GeneratedColumn<bool> ccEnabled = GeneratedColumn<bool>(
    'cc_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cc_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.07),
  );
  static const VerificationMeta _ccRateMeta = const VerificationMeta('ccRate');
  @override
  late final GeneratedColumn<double> ccRate = GeneratedColumn<double>(
    'cc_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.03),
  );
  static const VerificationMeta _pricingProfileIdMeta = const VerificationMeta(
    'pricingProfileId',
  );
  @override
  late final GeneratedColumn<String> pricingProfileId = GeneratedColumn<String>(
    'pricing_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('default'),
  );
  static const VerificationMeta _defaultRoomTypeMeta = const VerificationMeta(
    'defaultRoomType',
  );
  @override
  late final GeneratedColumn<String> defaultRoomType = GeneratedColumn<String>(
    'default_room_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _defaultLevelMeta = const VerificationMeta(
    'defaultLevel',
  );
  @override
  late final GeneratedColumn<String> defaultLevel = GeneratedColumn<String>(
    'default_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _defaultSizeMeta = const VerificationMeta(
    'defaultSize',
  );
  @override
  late final GeneratedColumn<String> defaultSize = GeneratedColumn<String>(
    'default_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _defaultComplexityMeta = const VerificationMeta(
    'defaultComplexity',
  );
  @override
  late final GeneratedColumn<String> defaultComplexity =
      GeneratedColumn<String>(
        'default_complexity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _subItemTypeMeta = const VerificationMeta(
    'subItemType',
  );
  @override
  late final GeneratedColumn<String> subItemType = GeneratedColumn<String>(
    'sub_item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _specialNotesMeta = const VerificationMeta(
    'specialNotes',
  );
  @override
  late final GeneratedColumn<String> specialNotes = GeneratedColumn<String>(
    'special_notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    updatedAt,
    deleted,
    clientId,
    clientName,
    quoteName,
    quoteDate,
    serviceType,
    frequency,
    lastProClean,
    status,
    total,
    address,
    totalSqFt,
    useTotalSqFt,
    estimatedSqFt,
    petsPresent,
    homeOccupied,
    entryCode,
    paymentMethod,
    feedbackDiscussed,
    laborRate,
    taxEnabled,
    ccEnabled,
    taxRate,
    ccRate,
    pricingProfileId,
    defaultRoomType,
    defaultLevel,
    defaultSize,
    defaultComplexity,
    subItemType,
    specialNotes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotes';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('client_name')) {
      context.handle(
        _clientNameMeta,
        clientName.isAcceptableOrUnknown(data['client_name']!, _clientNameMeta),
      );
    }
    if (data.containsKey('quote_name')) {
      context.handle(
        _quoteNameMeta,
        quoteName.isAcceptableOrUnknown(data['quote_name']!, _quoteNameMeta),
      );
    }
    if (data.containsKey('quote_date')) {
      context.handle(
        _quoteDateMeta,
        quoteDate.isAcceptableOrUnknown(data['quote_date']!, _quoteDateMeta),
      );
    }
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('last_pro_clean')) {
      context.handle(
        _lastProCleanMeta,
        lastProClean.isAcceptableOrUnknown(
          data['last_pro_clean']!,
          _lastProCleanMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('total_sq_ft')) {
      context.handle(
        _totalSqFtMeta,
        totalSqFt.isAcceptableOrUnknown(data['total_sq_ft']!, _totalSqFtMeta),
      );
    }
    if (data.containsKey('use_total_sq_ft')) {
      context.handle(
        _useTotalSqFtMeta,
        useTotalSqFt.isAcceptableOrUnknown(
          data['use_total_sq_ft']!,
          _useTotalSqFtMeta,
        ),
      );
    }
    if (data.containsKey('estimated_sq_ft')) {
      context.handle(
        _estimatedSqFtMeta,
        estimatedSqFt.isAcceptableOrUnknown(
          data['estimated_sq_ft']!,
          _estimatedSqFtMeta,
        ),
      );
    }
    if (data.containsKey('pets_present')) {
      context.handle(
        _petsPresentMeta,
        petsPresent.isAcceptableOrUnknown(
          data['pets_present']!,
          _petsPresentMeta,
        ),
      );
    }
    if (data.containsKey('home_occupied')) {
      context.handle(
        _homeOccupiedMeta,
        homeOccupied.isAcceptableOrUnknown(
          data['home_occupied']!,
          _homeOccupiedMeta,
        ),
      );
    }
    if (data.containsKey('entry_code')) {
      context.handle(
        _entryCodeMeta,
        entryCode.isAcceptableOrUnknown(data['entry_code']!, _entryCodeMeta),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('feedback_discussed')) {
      context.handle(
        _feedbackDiscussedMeta,
        feedbackDiscussed.isAcceptableOrUnknown(
          data['feedback_discussed']!,
          _feedbackDiscussedMeta,
        ),
      );
    }
    if (data.containsKey('labor_rate')) {
      context.handle(
        _laborRateMeta,
        laborRate.isAcceptableOrUnknown(data['labor_rate']!, _laborRateMeta),
      );
    }
    if (data.containsKey('tax_enabled')) {
      context.handle(
        _taxEnabledMeta,
        taxEnabled.isAcceptableOrUnknown(data['tax_enabled']!, _taxEnabledMeta),
      );
    }
    if (data.containsKey('cc_enabled')) {
      context.handle(
        _ccEnabledMeta,
        ccEnabled.isAcceptableOrUnknown(data['cc_enabled']!, _ccEnabledMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('cc_rate')) {
      context.handle(
        _ccRateMeta,
        ccRate.isAcceptableOrUnknown(data['cc_rate']!, _ccRateMeta),
      );
    }
    if (data.containsKey('pricing_profile_id')) {
      context.handle(
        _pricingProfileIdMeta,
        pricingProfileId.isAcceptableOrUnknown(
          data['pricing_profile_id']!,
          _pricingProfileIdMeta,
        ),
      );
    }
    if (data.containsKey('default_room_type')) {
      context.handle(
        _defaultRoomTypeMeta,
        defaultRoomType.isAcceptableOrUnknown(
          data['default_room_type']!,
          _defaultRoomTypeMeta,
        ),
      );
    }
    if (data.containsKey('default_level')) {
      context.handle(
        _defaultLevelMeta,
        defaultLevel.isAcceptableOrUnknown(
          data['default_level']!,
          _defaultLevelMeta,
        ),
      );
    }
    if (data.containsKey('default_size')) {
      context.handle(
        _defaultSizeMeta,
        defaultSize.isAcceptableOrUnknown(
          data['default_size']!,
          _defaultSizeMeta,
        ),
      );
    }
    if (data.containsKey('default_complexity')) {
      context.handle(
        _defaultComplexityMeta,
        defaultComplexity.isAcceptableOrUnknown(
          data['default_complexity']!,
          _defaultComplexityMeta,
        ),
      );
    }
    if (data.containsKey('sub_item_type')) {
      context.handle(
        _subItemTypeMeta,
        subItemType.isAcceptableOrUnknown(
          data['sub_item_type']!,
          _subItemTypeMeta,
        ),
      );
    }
    if (data.containsKey('special_notes')) {
      context.handle(
        _specialNotesMeta,
        specialNotes.isAcceptableOrUnknown(
          data['special_notes']!,
          _specialNotesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      clientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_name'],
      )!,
      quoteName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_name'],
      )!,
      quoteDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_date'],
      )!,
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      lastProClean: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_pro_clean'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      totalSqFt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}total_sq_ft'],
      )!,
      useTotalSqFt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_total_sq_ft'],
      )!,
      estimatedSqFt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estimated_sq_ft'],
      )!,
      petsPresent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pets_present'],
      )!,
      homeOccupied: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_occupied'],
      )!,
      entryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_code'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      feedbackDiscussed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}feedback_discussed'],
      )!,
      laborRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}labor_rate'],
      )!,
      taxEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tax_enabled'],
      )!,
      ccEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cc_enabled'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      ccRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cc_rate'],
      )!,
      pricingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pricing_profile_id'],
      )!,
      defaultRoomType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_room_type'],
      )!,
      defaultLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_level'],
      )!,
      defaultSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_size'],
      )!,
      defaultComplexity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_complexity'],
      )!,
      subItemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_item_type'],
      )!,
      specialNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}special_notes'],
      )!,
    );
  }

  @override
  $QuotesTable createAlias(String alias) {
    return $QuotesTable(attachedDatabase, alias);
  }
}

class QuoteRow extends DataClass implements Insertable<QuoteRow> {
  final String id;
  final String orgId;
  final int updatedAt;
  final bool deleted;
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
  final String pricingProfileId;
  final String defaultRoomType;
  final String defaultLevel;
  final String defaultSize;
  final String defaultComplexity;
  final String subItemType;
  final String specialNotes;
  const QuoteRow({
    required this.id,
    required this.orgId,
    required this.updatedAt,
    required this.deleted,
    required this.clientId,
    required this.clientName,
    required this.quoteName,
    required this.quoteDate,
    required this.serviceType,
    required this.frequency,
    required this.lastProClean,
    required this.status,
    required this.total,
    required this.address,
    required this.totalSqFt,
    required this.useTotalSqFt,
    required this.estimatedSqFt,
    required this.petsPresent,
    required this.homeOccupied,
    required this.entryCode,
    required this.paymentMethod,
    required this.feedbackDiscussed,
    required this.laborRate,
    required this.taxEnabled,
    required this.ccEnabled,
    required this.taxRate,
    required this.ccRate,
    required this.pricingProfileId,
    required this.defaultRoomType,
    required this.defaultLevel,
    required this.defaultSize,
    required this.defaultComplexity,
    required this.subItemType,
    required this.specialNotes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['client_id'] = Variable<String>(clientId);
    map['client_name'] = Variable<String>(clientName);
    map['quote_name'] = Variable<String>(quoteName);
    map['quote_date'] = Variable<String>(quoteDate);
    map['service_type'] = Variable<String>(serviceType);
    map['frequency'] = Variable<String>(frequency);
    map['last_pro_clean'] = Variable<String>(lastProClean);
    map['status'] = Variable<String>(status);
    map['total'] = Variable<double>(total);
    map['address'] = Variable<String>(address);
    map['total_sq_ft'] = Variable<String>(totalSqFt);
    map['use_total_sq_ft'] = Variable<bool>(useTotalSqFt);
    map['estimated_sq_ft'] = Variable<String>(estimatedSqFt);
    map['pets_present'] = Variable<bool>(petsPresent);
    map['home_occupied'] = Variable<bool>(homeOccupied);
    map['entry_code'] = Variable<String>(entryCode);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['feedback_discussed'] = Variable<bool>(feedbackDiscussed);
    map['labor_rate'] = Variable<double>(laborRate);
    map['tax_enabled'] = Variable<bool>(taxEnabled);
    map['cc_enabled'] = Variable<bool>(ccEnabled);
    map['tax_rate'] = Variable<double>(taxRate);
    map['cc_rate'] = Variable<double>(ccRate);
    map['pricing_profile_id'] = Variable<String>(pricingProfileId);
    map['default_room_type'] = Variable<String>(defaultRoomType);
    map['default_level'] = Variable<String>(defaultLevel);
    map['default_size'] = Variable<String>(defaultSize);
    map['default_complexity'] = Variable<String>(defaultComplexity);
    map['sub_item_type'] = Variable<String>(subItemType);
    map['special_notes'] = Variable<String>(specialNotes);
    return map;
  }

  QuotesCompanion toCompanion(bool nullToAbsent) {
    return QuotesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      clientId: Value(clientId),
      clientName: Value(clientName),
      quoteName: Value(quoteName),
      quoteDate: Value(quoteDate),
      serviceType: Value(serviceType),
      frequency: Value(frequency),
      lastProClean: Value(lastProClean),
      status: Value(status),
      total: Value(total),
      address: Value(address),
      totalSqFt: Value(totalSqFt),
      useTotalSqFt: Value(useTotalSqFt),
      estimatedSqFt: Value(estimatedSqFt),
      petsPresent: Value(petsPresent),
      homeOccupied: Value(homeOccupied),
      entryCode: Value(entryCode),
      paymentMethod: Value(paymentMethod),
      feedbackDiscussed: Value(feedbackDiscussed),
      laborRate: Value(laborRate),
      taxEnabled: Value(taxEnabled),
      ccEnabled: Value(ccEnabled),
      taxRate: Value(taxRate),
      ccRate: Value(ccRate),
      pricingProfileId: Value(pricingProfileId),
      defaultRoomType: Value(defaultRoomType),
      defaultLevel: Value(defaultLevel),
      defaultSize: Value(defaultSize),
      defaultComplexity: Value(defaultComplexity),
      subItemType: Value(subItemType),
      specialNotes: Value(specialNotes),
    );
  }

  factory QuoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      clientId: serializer.fromJson<String>(json['clientId']),
      clientName: serializer.fromJson<String>(json['clientName']),
      quoteName: serializer.fromJson<String>(json['quoteName']),
      quoteDate: serializer.fromJson<String>(json['quoteDate']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      frequency: serializer.fromJson<String>(json['frequency']),
      lastProClean: serializer.fromJson<String>(json['lastProClean']),
      status: serializer.fromJson<String>(json['status']),
      total: serializer.fromJson<double>(json['total']),
      address: serializer.fromJson<String>(json['address']),
      totalSqFt: serializer.fromJson<String>(json['totalSqFt']),
      useTotalSqFt: serializer.fromJson<bool>(json['useTotalSqFt']),
      estimatedSqFt: serializer.fromJson<String>(json['estimatedSqFt']),
      petsPresent: serializer.fromJson<bool>(json['petsPresent']),
      homeOccupied: serializer.fromJson<bool>(json['homeOccupied']),
      entryCode: serializer.fromJson<String>(json['entryCode']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      feedbackDiscussed: serializer.fromJson<bool>(json['feedbackDiscussed']),
      laborRate: serializer.fromJson<double>(json['laborRate']),
      taxEnabled: serializer.fromJson<bool>(json['taxEnabled']),
      ccEnabled: serializer.fromJson<bool>(json['ccEnabled']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      ccRate: serializer.fromJson<double>(json['ccRate']),
      pricingProfileId: serializer.fromJson<String>(json['pricingProfileId']),
      defaultRoomType: serializer.fromJson<String>(json['defaultRoomType']),
      defaultLevel: serializer.fromJson<String>(json['defaultLevel']),
      defaultSize: serializer.fromJson<String>(json['defaultSize']),
      defaultComplexity: serializer.fromJson<String>(json['defaultComplexity']),
      subItemType: serializer.fromJson<String>(json['subItemType']),
      specialNotes: serializer.fromJson<String>(json['specialNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'clientId': serializer.toJson<String>(clientId),
      'clientName': serializer.toJson<String>(clientName),
      'quoteName': serializer.toJson<String>(quoteName),
      'quoteDate': serializer.toJson<String>(quoteDate),
      'serviceType': serializer.toJson<String>(serviceType),
      'frequency': serializer.toJson<String>(frequency),
      'lastProClean': serializer.toJson<String>(lastProClean),
      'status': serializer.toJson<String>(status),
      'total': serializer.toJson<double>(total),
      'address': serializer.toJson<String>(address),
      'totalSqFt': serializer.toJson<String>(totalSqFt),
      'useTotalSqFt': serializer.toJson<bool>(useTotalSqFt),
      'estimatedSqFt': serializer.toJson<String>(estimatedSqFt),
      'petsPresent': serializer.toJson<bool>(petsPresent),
      'homeOccupied': serializer.toJson<bool>(homeOccupied),
      'entryCode': serializer.toJson<String>(entryCode),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'feedbackDiscussed': serializer.toJson<bool>(feedbackDiscussed),
      'laborRate': serializer.toJson<double>(laborRate),
      'taxEnabled': serializer.toJson<bool>(taxEnabled),
      'ccEnabled': serializer.toJson<bool>(ccEnabled),
      'taxRate': serializer.toJson<double>(taxRate),
      'ccRate': serializer.toJson<double>(ccRate),
      'pricingProfileId': serializer.toJson<String>(pricingProfileId),
      'defaultRoomType': serializer.toJson<String>(defaultRoomType),
      'defaultLevel': serializer.toJson<String>(defaultLevel),
      'defaultSize': serializer.toJson<String>(defaultSize),
      'defaultComplexity': serializer.toJson<String>(defaultComplexity),
      'subItemType': serializer.toJson<String>(subItemType),
      'specialNotes': serializer.toJson<String>(specialNotes),
    };
  }

  QuoteRow copyWith({
    String? id,
    String? orgId,
    int? updatedAt,
    bool? deleted,
    String? clientId,
    String? clientName,
    String? quoteName,
    String? quoteDate,
    String? serviceType,
    String? frequency,
    String? lastProClean,
    String? status,
    double? total,
    String? address,
    String? totalSqFt,
    bool? useTotalSqFt,
    String? estimatedSqFt,
    bool? petsPresent,
    bool? homeOccupied,
    String? entryCode,
    String? paymentMethod,
    bool? feedbackDiscussed,
    double? laborRate,
    bool? taxEnabled,
    bool? ccEnabled,
    double? taxRate,
    double? ccRate,
    String? pricingProfileId,
    String? defaultRoomType,
    String? defaultLevel,
    String? defaultSize,
    String? defaultComplexity,
    String? subItemType,
    String? specialNotes,
  }) => QuoteRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    clientId: clientId ?? this.clientId,
    clientName: clientName ?? this.clientName,
    quoteName: quoteName ?? this.quoteName,
    quoteDate: quoteDate ?? this.quoteDate,
    serviceType: serviceType ?? this.serviceType,
    frequency: frequency ?? this.frequency,
    lastProClean: lastProClean ?? this.lastProClean,
    status: status ?? this.status,
    total: total ?? this.total,
    address: address ?? this.address,
    totalSqFt: totalSqFt ?? this.totalSqFt,
    useTotalSqFt: useTotalSqFt ?? this.useTotalSqFt,
    estimatedSqFt: estimatedSqFt ?? this.estimatedSqFt,
    petsPresent: petsPresent ?? this.petsPresent,
    homeOccupied: homeOccupied ?? this.homeOccupied,
    entryCode: entryCode ?? this.entryCode,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    feedbackDiscussed: feedbackDiscussed ?? this.feedbackDiscussed,
    laborRate: laborRate ?? this.laborRate,
    taxEnabled: taxEnabled ?? this.taxEnabled,
    ccEnabled: ccEnabled ?? this.ccEnabled,
    taxRate: taxRate ?? this.taxRate,
    ccRate: ccRate ?? this.ccRate,
    pricingProfileId: pricingProfileId ?? this.pricingProfileId,
    defaultRoomType: defaultRoomType ?? this.defaultRoomType,
    defaultLevel: defaultLevel ?? this.defaultLevel,
    defaultSize: defaultSize ?? this.defaultSize,
    defaultComplexity: defaultComplexity ?? this.defaultComplexity,
    subItemType: subItemType ?? this.subItemType,
    specialNotes: specialNotes ?? this.specialNotes,
  );
  QuoteRow copyWithCompanion(QuotesCompanion data) {
    return QuoteRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      clientName: data.clientName.present
          ? data.clientName.value
          : this.clientName,
      quoteName: data.quoteName.present ? data.quoteName.value : this.quoteName,
      quoteDate: data.quoteDate.present ? data.quoteDate.value : this.quoteDate,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      lastProClean: data.lastProClean.present
          ? data.lastProClean.value
          : this.lastProClean,
      status: data.status.present ? data.status.value : this.status,
      total: data.total.present ? data.total.value : this.total,
      address: data.address.present ? data.address.value : this.address,
      totalSqFt: data.totalSqFt.present ? data.totalSqFt.value : this.totalSqFt,
      useTotalSqFt: data.useTotalSqFt.present
          ? data.useTotalSqFt.value
          : this.useTotalSqFt,
      estimatedSqFt: data.estimatedSqFt.present
          ? data.estimatedSqFt.value
          : this.estimatedSqFt,
      petsPresent: data.petsPresent.present
          ? data.petsPresent.value
          : this.petsPresent,
      homeOccupied: data.homeOccupied.present
          ? data.homeOccupied.value
          : this.homeOccupied,
      entryCode: data.entryCode.present ? data.entryCode.value : this.entryCode,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      feedbackDiscussed: data.feedbackDiscussed.present
          ? data.feedbackDiscussed.value
          : this.feedbackDiscussed,
      laborRate: data.laborRate.present ? data.laborRate.value : this.laborRate,
      taxEnabled: data.taxEnabled.present
          ? data.taxEnabled.value
          : this.taxEnabled,
      ccEnabled: data.ccEnabled.present ? data.ccEnabled.value : this.ccEnabled,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      ccRate: data.ccRate.present ? data.ccRate.value : this.ccRate,
      pricingProfileId: data.pricingProfileId.present
          ? data.pricingProfileId.value
          : this.pricingProfileId,
      defaultRoomType: data.defaultRoomType.present
          ? data.defaultRoomType.value
          : this.defaultRoomType,
      defaultLevel: data.defaultLevel.present
          ? data.defaultLevel.value
          : this.defaultLevel,
      defaultSize: data.defaultSize.present
          ? data.defaultSize.value
          : this.defaultSize,
      defaultComplexity: data.defaultComplexity.present
          ? data.defaultComplexity.value
          : this.defaultComplexity,
      subItemType: data.subItemType.present
          ? data.subItemType.value
          : this.subItemType,
      specialNotes: data.specialNotes.present
          ? data.specialNotes.value
          : this.specialNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuoteRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('clientId: $clientId, ')
          ..write('clientName: $clientName, ')
          ..write('quoteName: $quoteName, ')
          ..write('quoteDate: $quoteDate, ')
          ..write('serviceType: $serviceType, ')
          ..write('frequency: $frequency, ')
          ..write('lastProClean: $lastProClean, ')
          ..write('status: $status, ')
          ..write('total: $total, ')
          ..write('address: $address, ')
          ..write('totalSqFt: $totalSqFt, ')
          ..write('useTotalSqFt: $useTotalSqFt, ')
          ..write('estimatedSqFt: $estimatedSqFt, ')
          ..write('petsPresent: $petsPresent, ')
          ..write('homeOccupied: $homeOccupied, ')
          ..write('entryCode: $entryCode, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('feedbackDiscussed: $feedbackDiscussed, ')
          ..write('laborRate: $laborRate, ')
          ..write('taxEnabled: $taxEnabled, ')
          ..write('ccEnabled: $ccEnabled, ')
          ..write('taxRate: $taxRate, ')
          ..write('ccRate: $ccRate, ')
          ..write('pricingProfileId: $pricingProfileId, ')
          ..write('defaultRoomType: $defaultRoomType, ')
          ..write('defaultLevel: $defaultLevel, ')
          ..write('defaultSize: $defaultSize, ')
          ..write('defaultComplexity: $defaultComplexity, ')
          ..write('subItemType: $subItemType, ')
          ..write('specialNotes: $specialNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    orgId,
    updatedAt,
    deleted,
    clientId,
    clientName,
    quoteName,
    quoteDate,
    serviceType,
    frequency,
    lastProClean,
    status,
    total,
    address,
    totalSqFt,
    useTotalSqFt,
    estimatedSqFt,
    petsPresent,
    homeOccupied,
    entryCode,
    paymentMethod,
    feedbackDiscussed,
    laborRate,
    taxEnabled,
    ccEnabled,
    taxRate,
    ccRate,
    pricingProfileId,
    defaultRoomType,
    defaultLevel,
    defaultSize,
    defaultComplexity,
    subItemType,
    specialNotes,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuoteRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.clientId == this.clientId &&
          other.clientName == this.clientName &&
          other.quoteName == this.quoteName &&
          other.quoteDate == this.quoteDate &&
          other.serviceType == this.serviceType &&
          other.frequency == this.frequency &&
          other.lastProClean == this.lastProClean &&
          other.status == this.status &&
          other.total == this.total &&
          other.address == this.address &&
          other.totalSqFt == this.totalSqFt &&
          other.useTotalSqFt == this.useTotalSqFt &&
          other.estimatedSqFt == this.estimatedSqFt &&
          other.petsPresent == this.petsPresent &&
          other.homeOccupied == this.homeOccupied &&
          other.entryCode == this.entryCode &&
          other.paymentMethod == this.paymentMethod &&
          other.feedbackDiscussed == this.feedbackDiscussed &&
          other.laborRate == this.laborRate &&
          other.taxEnabled == this.taxEnabled &&
          other.ccEnabled == this.ccEnabled &&
          other.taxRate == this.taxRate &&
          other.ccRate == this.ccRate &&
          other.pricingProfileId == this.pricingProfileId &&
          other.defaultRoomType == this.defaultRoomType &&
          other.defaultLevel == this.defaultLevel &&
          other.defaultSize == this.defaultSize &&
          other.defaultComplexity == this.defaultComplexity &&
          other.subItemType == this.subItemType &&
          other.specialNotes == this.specialNotes);
}

class QuotesCompanion extends UpdateCompanion<QuoteRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<String> clientId;
  final Value<String> clientName;
  final Value<String> quoteName;
  final Value<String> quoteDate;
  final Value<String> serviceType;
  final Value<String> frequency;
  final Value<String> lastProClean;
  final Value<String> status;
  final Value<double> total;
  final Value<String> address;
  final Value<String> totalSqFt;
  final Value<bool> useTotalSqFt;
  final Value<String> estimatedSqFt;
  final Value<bool> petsPresent;
  final Value<bool> homeOccupied;
  final Value<String> entryCode;
  final Value<String> paymentMethod;
  final Value<bool> feedbackDiscussed;
  final Value<double> laborRate;
  final Value<bool> taxEnabled;
  final Value<bool> ccEnabled;
  final Value<double> taxRate;
  final Value<double> ccRate;
  final Value<String> pricingProfileId;
  final Value<String> defaultRoomType;
  final Value<String> defaultLevel;
  final Value<String> defaultSize;
  final Value<String> defaultComplexity;
  final Value<String> subItemType;
  final Value<String> specialNotes;
  final Value<int> rowid;
  const QuotesCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.clientId = const Value.absent(),
    this.clientName = const Value.absent(),
    this.quoteName = const Value.absent(),
    this.quoteDate = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.frequency = const Value.absent(),
    this.lastProClean = const Value.absent(),
    this.status = const Value.absent(),
    this.total = const Value.absent(),
    this.address = const Value.absent(),
    this.totalSqFt = const Value.absent(),
    this.useTotalSqFt = const Value.absent(),
    this.estimatedSqFt = const Value.absent(),
    this.petsPresent = const Value.absent(),
    this.homeOccupied = const Value.absent(),
    this.entryCode = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.feedbackDiscussed = const Value.absent(),
    this.laborRate = const Value.absent(),
    this.taxEnabled = const Value.absent(),
    this.ccEnabled = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.ccRate = const Value.absent(),
    this.pricingProfileId = const Value.absent(),
    this.defaultRoomType = const Value.absent(),
    this.defaultLevel = const Value.absent(),
    this.defaultSize = const Value.absent(),
    this.defaultComplexity = const Value.absent(),
    this.subItemType = const Value.absent(),
    this.specialNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuotesCompanion.insert({
    required String id,
    required String orgId,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.clientId = const Value.absent(),
    this.clientName = const Value.absent(),
    this.quoteName = const Value.absent(),
    this.quoteDate = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.frequency = const Value.absent(),
    this.lastProClean = const Value.absent(),
    this.status = const Value.absent(),
    this.total = const Value.absent(),
    this.address = const Value.absent(),
    this.totalSqFt = const Value.absent(),
    this.useTotalSqFt = const Value.absent(),
    this.estimatedSqFt = const Value.absent(),
    this.petsPresent = const Value.absent(),
    this.homeOccupied = const Value.absent(),
    this.entryCode = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.feedbackDiscussed = const Value.absent(),
    this.laborRate = const Value.absent(),
    this.taxEnabled = const Value.absent(),
    this.ccEnabled = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.ccRate = const Value.absent(),
    this.pricingProfileId = const Value.absent(),
    this.defaultRoomType = const Value.absent(),
    this.defaultLevel = const Value.absent(),
    this.defaultSize = const Value.absent(),
    this.defaultComplexity = const Value.absent(),
    this.subItemType = const Value.absent(),
    this.specialNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       updatedAt = Value(updatedAt);
  static Insertable<QuoteRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? clientId,
    Expression<String>? clientName,
    Expression<String>? quoteName,
    Expression<String>? quoteDate,
    Expression<String>? serviceType,
    Expression<String>? frequency,
    Expression<String>? lastProClean,
    Expression<String>? status,
    Expression<double>? total,
    Expression<String>? address,
    Expression<String>? totalSqFt,
    Expression<bool>? useTotalSqFt,
    Expression<String>? estimatedSqFt,
    Expression<bool>? petsPresent,
    Expression<bool>? homeOccupied,
    Expression<String>? entryCode,
    Expression<String>? paymentMethod,
    Expression<bool>? feedbackDiscussed,
    Expression<double>? laborRate,
    Expression<bool>? taxEnabled,
    Expression<bool>? ccEnabled,
    Expression<double>? taxRate,
    Expression<double>? ccRate,
    Expression<String>? pricingProfileId,
    Expression<String>? defaultRoomType,
    Expression<String>? defaultLevel,
    Expression<String>? defaultSize,
    Expression<String>? defaultComplexity,
    Expression<String>? subItemType,
    Expression<String>? specialNotes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (clientId != null) 'client_id': clientId,
      if (clientName != null) 'client_name': clientName,
      if (quoteName != null) 'quote_name': quoteName,
      if (quoteDate != null) 'quote_date': quoteDate,
      if (serviceType != null) 'service_type': serviceType,
      if (frequency != null) 'frequency': frequency,
      if (lastProClean != null) 'last_pro_clean': lastProClean,
      if (status != null) 'status': status,
      if (total != null) 'total': total,
      if (address != null) 'address': address,
      if (totalSqFt != null) 'total_sq_ft': totalSqFt,
      if (useTotalSqFt != null) 'use_total_sq_ft': useTotalSqFt,
      if (estimatedSqFt != null) 'estimated_sq_ft': estimatedSqFt,
      if (petsPresent != null) 'pets_present': petsPresent,
      if (homeOccupied != null) 'home_occupied': homeOccupied,
      if (entryCode != null) 'entry_code': entryCode,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (feedbackDiscussed != null) 'feedback_discussed': feedbackDiscussed,
      if (laborRate != null) 'labor_rate': laborRate,
      if (taxEnabled != null) 'tax_enabled': taxEnabled,
      if (ccEnabled != null) 'cc_enabled': ccEnabled,
      if (taxRate != null) 'tax_rate': taxRate,
      if (ccRate != null) 'cc_rate': ccRate,
      if (pricingProfileId != null) 'pricing_profile_id': pricingProfileId,
      if (defaultRoomType != null) 'default_room_type': defaultRoomType,
      if (defaultLevel != null) 'default_level': defaultLevel,
      if (defaultSize != null) 'default_size': defaultSize,
      if (defaultComplexity != null) 'default_complexity': defaultComplexity,
      if (subItemType != null) 'sub_item_type': subItemType,
      if (specialNotes != null) 'special_notes': specialNotes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuotesCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<String>? clientId,
    Value<String>? clientName,
    Value<String>? quoteName,
    Value<String>? quoteDate,
    Value<String>? serviceType,
    Value<String>? frequency,
    Value<String>? lastProClean,
    Value<String>? status,
    Value<double>? total,
    Value<String>? address,
    Value<String>? totalSqFt,
    Value<bool>? useTotalSqFt,
    Value<String>? estimatedSqFt,
    Value<bool>? petsPresent,
    Value<bool>? homeOccupied,
    Value<String>? entryCode,
    Value<String>? paymentMethod,
    Value<bool>? feedbackDiscussed,
    Value<double>? laborRate,
    Value<bool>? taxEnabled,
    Value<bool>? ccEnabled,
    Value<double>? taxRate,
    Value<double>? ccRate,
    Value<String>? pricingProfileId,
    Value<String>? defaultRoomType,
    Value<String>? defaultLevel,
    Value<String>? defaultSize,
    Value<String>? defaultComplexity,
    Value<String>? subItemType,
    Value<String>? specialNotes,
    Value<int>? rowid,
  }) {
    return QuotesCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      quoteName: quoteName ?? this.quoteName,
      quoteDate: quoteDate ?? this.quoteDate,
      serviceType: serviceType ?? this.serviceType,
      frequency: frequency ?? this.frequency,
      lastProClean: lastProClean ?? this.lastProClean,
      status: status ?? this.status,
      total: total ?? this.total,
      address: address ?? this.address,
      totalSqFt: totalSqFt ?? this.totalSqFt,
      useTotalSqFt: useTotalSqFt ?? this.useTotalSqFt,
      estimatedSqFt: estimatedSqFt ?? this.estimatedSqFt,
      petsPresent: petsPresent ?? this.petsPresent,
      homeOccupied: homeOccupied ?? this.homeOccupied,
      entryCode: entryCode ?? this.entryCode,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      feedbackDiscussed: feedbackDiscussed ?? this.feedbackDiscussed,
      laborRate: laborRate ?? this.laborRate,
      taxEnabled: taxEnabled ?? this.taxEnabled,
      ccEnabled: ccEnabled ?? this.ccEnabled,
      taxRate: taxRate ?? this.taxRate,
      ccRate: ccRate ?? this.ccRate,
      pricingProfileId: pricingProfileId ?? this.pricingProfileId,
      defaultRoomType: defaultRoomType ?? this.defaultRoomType,
      defaultLevel: defaultLevel ?? this.defaultLevel,
      defaultSize: defaultSize ?? this.defaultSize,
      defaultComplexity: defaultComplexity ?? this.defaultComplexity,
      subItemType: subItemType ?? this.subItemType,
      specialNotes: specialNotes ?? this.specialNotes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (quoteName.present) {
      map['quote_name'] = Variable<String>(quoteName.value);
    }
    if (quoteDate.present) {
      map['quote_date'] = Variable<String>(quoteDate.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (lastProClean.present) {
      map['last_pro_clean'] = Variable<String>(lastProClean.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (totalSqFt.present) {
      map['total_sq_ft'] = Variable<String>(totalSqFt.value);
    }
    if (useTotalSqFt.present) {
      map['use_total_sq_ft'] = Variable<bool>(useTotalSqFt.value);
    }
    if (estimatedSqFt.present) {
      map['estimated_sq_ft'] = Variable<String>(estimatedSqFt.value);
    }
    if (petsPresent.present) {
      map['pets_present'] = Variable<bool>(petsPresent.value);
    }
    if (homeOccupied.present) {
      map['home_occupied'] = Variable<bool>(homeOccupied.value);
    }
    if (entryCode.present) {
      map['entry_code'] = Variable<String>(entryCode.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (feedbackDiscussed.present) {
      map['feedback_discussed'] = Variable<bool>(feedbackDiscussed.value);
    }
    if (laborRate.present) {
      map['labor_rate'] = Variable<double>(laborRate.value);
    }
    if (taxEnabled.present) {
      map['tax_enabled'] = Variable<bool>(taxEnabled.value);
    }
    if (ccEnabled.present) {
      map['cc_enabled'] = Variable<bool>(ccEnabled.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (ccRate.present) {
      map['cc_rate'] = Variable<double>(ccRate.value);
    }
    if (pricingProfileId.present) {
      map['pricing_profile_id'] = Variable<String>(pricingProfileId.value);
    }
    if (defaultRoomType.present) {
      map['default_room_type'] = Variable<String>(defaultRoomType.value);
    }
    if (defaultLevel.present) {
      map['default_level'] = Variable<String>(defaultLevel.value);
    }
    if (defaultSize.present) {
      map['default_size'] = Variable<String>(defaultSize.value);
    }
    if (defaultComplexity.present) {
      map['default_complexity'] = Variable<String>(defaultComplexity.value);
    }
    if (subItemType.present) {
      map['sub_item_type'] = Variable<String>(subItemType.value);
    }
    if (specialNotes.present) {
      map['special_notes'] = Variable<String>(specialNotes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotesCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('clientId: $clientId, ')
          ..write('clientName: $clientName, ')
          ..write('quoteName: $quoteName, ')
          ..write('quoteDate: $quoteDate, ')
          ..write('serviceType: $serviceType, ')
          ..write('frequency: $frequency, ')
          ..write('lastProClean: $lastProClean, ')
          ..write('status: $status, ')
          ..write('total: $total, ')
          ..write('address: $address, ')
          ..write('totalSqFt: $totalSqFt, ')
          ..write('useTotalSqFt: $useTotalSqFt, ')
          ..write('estimatedSqFt: $estimatedSqFt, ')
          ..write('petsPresent: $petsPresent, ')
          ..write('homeOccupied: $homeOccupied, ')
          ..write('entryCode: $entryCode, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('feedbackDiscussed: $feedbackDiscussed, ')
          ..write('laborRate: $laborRate, ')
          ..write('taxEnabled: $taxEnabled, ')
          ..write('ccEnabled: $ccEnabled, ')
          ..write('taxRate: $taxRate, ')
          ..write('ccRate: $ccRate, ')
          ..write('pricingProfileId: $pricingProfileId, ')
          ..write('defaultRoomType: $defaultRoomType, ')
          ..write('defaultLevel: $defaultLevel, ')
          ..write('defaultSize: $defaultSize, ')
          ..write('defaultComplexity: $defaultComplexity, ')
          ..write('subItemType: $subItemType, ')
          ..write('specialNotes: $specialNotes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuoteItemsTable extends QuoteItems
    with TableInfo<$QuoteItemsTable, QuoteItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    quoteId,
    updatedAt,
    deleted,
    sortOrder,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuoteItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuoteItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $QuoteItemsTable createAlias(String alias) {
    return $QuoteItemsTable(attachedDatabase, alias);
  }
}

class QuoteItemRow extends DataClass implements Insertable<QuoteItemRow> {
  final String id;
  final String orgId;
  final String quoteId;
  final int updatedAt;
  final bool deleted;
  final int sortOrder;
  final String payload;
  const QuoteItemRow({
    required this.id,
    required this.orgId,
    required this.quoteId,
    required this.updatedAt,
    required this.deleted,
    required this.sortOrder,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['quote_id'] = Variable<String>(quoteId);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['sort_order'] = Variable<int>(sortOrder);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  QuoteItemsCompanion toCompanion(bool nullToAbsent) {
    return QuoteItemsCompanion(
      id: Value(id),
      orgId: Value(orgId),
      quoteId: Value(quoteId),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      sortOrder: Value(sortOrder),
      payload: Value(payload),
    );
  }

  factory QuoteItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteItemRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'quoteId': serializer.toJson<String>(quoteId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'payload': serializer.toJson<String>(payload),
    };
  }

  QuoteItemRow copyWith({
    String? id,
    String? orgId,
    String? quoteId,
    int? updatedAt,
    bool? deleted,
    int? sortOrder,
    String? payload,
  }) => QuoteItemRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    quoteId: quoteId ?? this.quoteId,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    sortOrder: sortOrder ?? this.sortOrder,
    payload: payload ?? this.payload,
  );
  QuoteItemRow copyWithCompanion(QuoteItemsCompanion data) {
    return QuoteItemRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuoteItemRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('quoteId: $quoteId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orgId, quoteId, updatedAt, deleted, sortOrder, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuoteItemRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.quoteId == this.quoteId &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.sortOrder == this.sortOrder &&
          other.payload == this.payload);
}

class QuoteItemsCompanion extends UpdateCompanion<QuoteItemRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> quoteId;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> sortOrder;
  final Value<String> payload;
  final Value<int> rowid;
  const QuoteItemsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuoteItemsCompanion.insert({
    required String id,
    required String orgId,
    required String quoteId,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       quoteId = Value(quoteId),
       updatedAt = Value(updatedAt);
  static Insertable<QuoteItemRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? quoteId,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? sortOrder,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (quoteId != null) 'quote_id': quoteId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuoteItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? quoteId,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? sortOrder,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return QuoteItemsCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      quoteId: quoteId ?? this.quoteId,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      sortOrder: sortOrder ?? this.sortOrder,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuoteItemsCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('quoteId: $quoteId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrgSettingsTableTable extends OrgSettingsTable
    with TableInfo<$OrgSettingsTableTable, OrgSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrgSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _laborRateMeta = const VerificationMeta(
    'laborRate',
  );
  @override
  late final GeneratedColumn<double> laborRate = GeneratedColumn<double>(
    'labor_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(40.0),
  );
  static const VerificationMeta _taxEnabledMeta = const VerificationMeta(
    'taxEnabled',
  );
  @override
  late final GeneratedColumn<bool> taxEnabled = GeneratedColumn<bool>(
    'tax_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tax_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.07),
  );
  static const VerificationMeta _ccEnabledMeta = const VerificationMeta(
    'ccEnabled',
  );
  @override
  late final GeneratedColumn<bool> ccEnabled = GeneratedColumn<bool>(
    'cc_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cc_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ccRateMeta = const VerificationMeta('ccRate');
  @override
  late final GeneratedColumn<double> ccRate = GeneratedColumn<double>(
    'cc_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.03),
  );
  static const VerificationMeta _defaultPricingProfileIdMeta =
      const VerificationMeta('defaultPricingProfileId');
  @override
  late final GeneratedColumn<String> defaultPricingProfileId =
      GeneratedColumn<String>(
        'default_pricing_profile_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('default'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    orgId,
    updatedAt,
    deleted,
    laborRate,
    taxEnabled,
    taxRate,
    ccEnabled,
    ccRate,
    defaultPricingProfileId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'org_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrgSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('labor_rate')) {
      context.handle(
        _laborRateMeta,
        laborRate.isAcceptableOrUnknown(data['labor_rate']!, _laborRateMeta),
      );
    }
    if (data.containsKey('tax_enabled')) {
      context.handle(
        _taxEnabledMeta,
        taxEnabled.isAcceptableOrUnknown(data['tax_enabled']!, _taxEnabledMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('cc_enabled')) {
      context.handle(
        _ccEnabledMeta,
        ccEnabled.isAcceptableOrUnknown(data['cc_enabled']!, _ccEnabledMeta),
      );
    }
    if (data.containsKey('cc_rate')) {
      context.handle(
        _ccRateMeta,
        ccRate.isAcceptableOrUnknown(data['cc_rate']!, _ccRateMeta),
      );
    }
    if (data.containsKey('default_pricing_profile_id')) {
      context.handle(
        _defaultPricingProfileIdMeta,
        defaultPricingProfileId.isAcceptableOrUnknown(
          data['default_pricing_profile_id']!,
          _defaultPricingProfileIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {orgId};
  @override
  OrgSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrgSettingsRow(
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      laborRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}labor_rate'],
      )!,
      taxEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tax_enabled'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      ccEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cc_enabled'],
      )!,
      ccRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cc_rate'],
      )!,
      defaultPricingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_pricing_profile_id'],
      )!,
    );
  }

  @override
  $OrgSettingsTableTable createAlias(String alias) {
    return $OrgSettingsTableTable(attachedDatabase, alias);
  }
}

class OrgSettingsRow extends DataClass implements Insertable<OrgSettingsRow> {
  final String orgId;
  final int updatedAt;
  final bool deleted;
  final double laborRate;
  final bool taxEnabled;
  final double taxRate;
  final bool ccEnabled;
  final double ccRate;
  final String defaultPricingProfileId;
  const OrgSettingsRow({
    required this.orgId,
    required this.updatedAt,
    required this.deleted,
    required this.laborRate,
    required this.taxEnabled,
    required this.taxRate,
    required this.ccEnabled,
    required this.ccRate,
    required this.defaultPricingProfileId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['org_id'] = Variable<String>(orgId);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['labor_rate'] = Variable<double>(laborRate);
    map['tax_enabled'] = Variable<bool>(taxEnabled);
    map['tax_rate'] = Variable<double>(taxRate);
    map['cc_enabled'] = Variable<bool>(ccEnabled);
    map['cc_rate'] = Variable<double>(ccRate);
    map['default_pricing_profile_id'] = Variable<String>(
      defaultPricingProfileId,
    );
    return map;
  }

  OrgSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return OrgSettingsTableCompanion(
      orgId: Value(orgId),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      laborRate: Value(laborRate),
      taxEnabled: Value(taxEnabled),
      taxRate: Value(taxRate),
      ccEnabled: Value(ccEnabled),
      ccRate: Value(ccRate),
      defaultPricingProfileId: Value(defaultPricingProfileId),
    );
  }

  factory OrgSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrgSettingsRow(
      orgId: serializer.fromJson<String>(json['orgId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      laborRate: serializer.fromJson<double>(json['laborRate']),
      taxEnabled: serializer.fromJson<bool>(json['taxEnabled']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      ccEnabled: serializer.fromJson<bool>(json['ccEnabled']),
      ccRate: serializer.fromJson<double>(json['ccRate']),
      defaultPricingProfileId: serializer.fromJson<String>(
        json['defaultPricingProfileId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orgId': serializer.toJson<String>(orgId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'laborRate': serializer.toJson<double>(laborRate),
      'taxEnabled': serializer.toJson<bool>(taxEnabled),
      'taxRate': serializer.toJson<double>(taxRate),
      'ccEnabled': serializer.toJson<bool>(ccEnabled),
      'ccRate': serializer.toJson<double>(ccRate),
      'defaultPricingProfileId': serializer.toJson<String>(
        defaultPricingProfileId,
      ),
    };
  }

  OrgSettingsRow copyWith({
    String? orgId,
    int? updatedAt,
    bool? deleted,
    double? laborRate,
    bool? taxEnabled,
    double? taxRate,
    bool? ccEnabled,
    double? ccRate,
    String? defaultPricingProfileId,
  }) => OrgSettingsRow(
    orgId: orgId ?? this.orgId,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    laborRate: laborRate ?? this.laborRate,
    taxEnabled: taxEnabled ?? this.taxEnabled,
    taxRate: taxRate ?? this.taxRate,
    ccEnabled: ccEnabled ?? this.ccEnabled,
    ccRate: ccRate ?? this.ccRate,
    defaultPricingProfileId:
        defaultPricingProfileId ?? this.defaultPricingProfileId,
  );
  OrgSettingsRow copyWithCompanion(OrgSettingsTableCompanion data) {
    return OrgSettingsRow(
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      laborRate: data.laborRate.present ? data.laborRate.value : this.laborRate,
      taxEnabled: data.taxEnabled.present
          ? data.taxEnabled.value
          : this.taxEnabled,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      ccEnabled: data.ccEnabled.present ? data.ccEnabled.value : this.ccEnabled,
      ccRate: data.ccRate.present ? data.ccRate.value : this.ccRate,
      defaultPricingProfileId: data.defaultPricingProfileId.present
          ? data.defaultPricingProfileId.value
          : this.defaultPricingProfileId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrgSettingsRow(')
          ..write('orgId: $orgId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('laborRate: $laborRate, ')
          ..write('taxEnabled: $taxEnabled, ')
          ..write('taxRate: $taxRate, ')
          ..write('ccEnabled: $ccEnabled, ')
          ..write('ccRate: $ccRate, ')
          ..write('defaultPricingProfileId: $defaultPricingProfileId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    orgId,
    updatedAt,
    deleted,
    laborRate,
    taxEnabled,
    taxRate,
    ccEnabled,
    ccRate,
    defaultPricingProfileId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrgSettingsRow &&
          other.orgId == this.orgId &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.laborRate == this.laborRate &&
          other.taxEnabled == this.taxEnabled &&
          other.taxRate == this.taxRate &&
          other.ccEnabled == this.ccEnabled &&
          other.ccRate == this.ccRate &&
          other.defaultPricingProfileId == this.defaultPricingProfileId);
}

class OrgSettingsTableCompanion extends UpdateCompanion<OrgSettingsRow> {
  final Value<String> orgId;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<double> laborRate;
  final Value<bool> taxEnabled;
  final Value<double> taxRate;
  final Value<bool> ccEnabled;
  final Value<double> ccRate;
  final Value<String> defaultPricingProfileId;
  final Value<int> rowid;
  const OrgSettingsTableCompanion({
    this.orgId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.laborRate = const Value.absent(),
    this.taxEnabled = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.ccEnabled = const Value.absent(),
    this.ccRate = const Value.absent(),
    this.defaultPricingProfileId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrgSettingsTableCompanion.insert({
    required String orgId,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.laborRate = const Value.absent(),
    this.taxEnabled = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.ccEnabled = const Value.absent(),
    this.ccRate = const Value.absent(),
    this.defaultPricingProfileId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : orgId = Value(orgId),
       updatedAt = Value(updatedAt);
  static Insertable<OrgSettingsRow> custom({
    Expression<String>? orgId,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<double>? laborRate,
    Expression<bool>? taxEnabled,
    Expression<double>? taxRate,
    Expression<bool>? ccEnabled,
    Expression<double>? ccRate,
    Expression<String>? defaultPricingProfileId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orgId != null) 'org_id': orgId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (laborRate != null) 'labor_rate': laborRate,
      if (taxEnabled != null) 'tax_enabled': taxEnabled,
      if (taxRate != null) 'tax_rate': taxRate,
      if (ccEnabled != null) 'cc_enabled': ccEnabled,
      if (ccRate != null) 'cc_rate': ccRate,
      if (defaultPricingProfileId != null)
        'default_pricing_profile_id': defaultPricingProfileId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrgSettingsTableCompanion copyWith({
    Value<String>? orgId,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<double>? laborRate,
    Value<bool>? taxEnabled,
    Value<double>? taxRate,
    Value<bool>? ccEnabled,
    Value<double>? ccRate,
    Value<String>? defaultPricingProfileId,
    Value<int>? rowid,
  }) {
    return OrgSettingsTableCompanion(
      orgId: orgId ?? this.orgId,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      laborRate: laborRate ?? this.laborRate,
      taxEnabled: taxEnabled ?? this.taxEnabled,
      taxRate: taxRate ?? this.taxRate,
      ccEnabled: ccEnabled ?? this.ccEnabled,
      ccRate: ccRate ?? this.ccRate,
      defaultPricingProfileId:
          defaultPricingProfileId ?? this.defaultPricingProfileId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (laborRate.present) {
      map['labor_rate'] = Variable<double>(laborRate.value);
    }
    if (taxEnabled.present) {
      map['tax_enabled'] = Variable<bool>(taxEnabled.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (ccEnabled.present) {
      map['cc_enabled'] = Variable<bool>(ccEnabled.value);
    }
    if (ccRate.present) {
      map['cc_rate'] = Variable<double>(ccRate.value);
    }
    if (defaultPricingProfileId.present) {
      map['default_pricing_profile_id'] = Variable<String>(
        defaultPricingProfileId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrgSettingsTableCompanion(')
          ..write('orgId: $orgId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('laborRate: $laborRate, ')
          ..write('taxEnabled: $taxEnabled, ')
          ..write('taxRate: $taxRate, ')
          ..write('ccEnabled: $ccEnabled, ')
          ..write('ccRate: $ccRate, ')
          ..write('defaultPricingProfileId: $defaultPricingProfileId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PricingProfilesTable extends PricingProfiles
    with TableInfo<$PricingProfilesTable, PricingProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricingProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _laborRateMeta = const VerificationMeta(
    'laborRate',
  );
  @override
  late final GeneratedColumn<double> laborRate = GeneratedColumn<double>(
    'labor_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(40.0),
  );
  static const VerificationMeta _taxEnabledMeta = const VerificationMeta(
    'taxEnabled',
  );
  @override
  late final GeneratedColumn<bool> taxEnabled = GeneratedColumn<bool>(
    'tax_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tax_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.07),
  );
  static const VerificationMeta _ccEnabledMeta = const VerificationMeta(
    'ccEnabled',
  );
  @override
  late final GeneratedColumn<bool> ccEnabled = GeneratedColumn<bool>(
    'cc_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cc_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ccRateMeta = const VerificationMeta('ccRate');
  @override
  late final GeneratedColumn<double> ccRate = GeneratedColumn<double>(
    'cc_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.03),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    name,
    laborRate,
    taxEnabled,
    taxRate,
    ccEnabled,
    ccRate,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pricing_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<PricingProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('labor_rate')) {
      context.handle(
        _laborRateMeta,
        laborRate.isAcceptableOrUnknown(data['labor_rate']!, _laborRateMeta),
      );
    }
    if (data.containsKey('tax_enabled')) {
      context.handle(
        _taxEnabledMeta,
        taxEnabled.isAcceptableOrUnknown(data['tax_enabled']!, _taxEnabledMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('cc_enabled')) {
      context.handle(
        _ccEnabledMeta,
        ccEnabled.isAcceptableOrUnknown(data['cc_enabled']!, _ccEnabledMeta),
      );
    }
    if (data.containsKey('cc_rate')) {
      context.handle(
        _ccRateMeta,
        ccRate.isAcceptableOrUnknown(data['cc_rate']!, _ccRateMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PricingProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PricingProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      laborRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}labor_rate'],
      )!,
      taxEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tax_enabled'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      ccEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cc_enabled'],
      )!,
      ccRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cc_rate'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $PricingProfilesTable createAlias(String alias) {
    return $PricingProfilesTable(attachedDatabase, alias);
  }
}

class PricingProfileRow extends DataClass
    implements Insertable<PricingProfileRow> {
  final String id;
  final String orgId;
  final String name;
  final double laborRate;
  final bool taxEnabled;
  final double taxRate;
  final bool ccEnabled;
  final double ccRate;
  final int updatedAt;
  final bool deleted;
  const PricingProfileRow({
    required this.id,
    required this.orgId,
    required this.name,
    required this.laborRate,
    required this.taxEnabled,
    required this.taxRate,
    required this.ccEnabled,
    required this.ccRate,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['name'] = Variable<String>(name);
    map['labor_rate'] = Variable<double>(laborRate);
    map['tax_enabled'] = Variable<bool>(taxEnabled);
    map['tax_rate'] = Variable<double>(taxRate);
    map['cc_enabled'] = Variable<bool>(ccEnabled);
    map['cc_rate'] = Variable<double>(ccRate);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  PricingProfilesCompanion toCompanion(bool nullToAbsent) {
    return PricingProfilesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      name: Value(name),
      laborRate: Value(laborRate),
      taxEnabled: Value(taxEnabled),
      taxRate: Value(taxRate),
      ccEnabled: Value(ccEnabled),
      ccRate: Value(ccRate),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory PricingProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PricingProfileRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      name: serializer.fromJson<String>(json['name']),
      laborRate: serializer.fromJson<double>(json['laborRate']),
      taxEnabled: serializer.fromJson<bool>(json['taxEnabled']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      ccEnabled: serializer.fromJson<bool>(json['ccEnabled']),
      ccRate: serializer.fromJson<double>(json['ccRate']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'name': serializer.toJson<String>(name),
      'laborRate': serializer.toJson<double>(laborRate),
      'taxEnabled': serializer.toJson<bool>(taxEnabled),
      'taxRate': serializer.toJson<double>(taxRate),
      'ccEnabled': serializer.toJson<bool>(ccEnabled),
      'ccRate': serializer.toJson<double>(ccRate),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  PricingProfileRow copyWith({
    String? id,
    String? orgId,
    String? name,
    double? laborRate,
    bool? taxEnabled,
    double? taxRate,
    bool? ccEnabled,
    double? ccRate,
    int? updatedAt,
    bool? deleted,
  }) => PricingProfileRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    name: name ?? this.name,
    laborRate: laborRate ?? this.laborRate,
    taxEnabled: taxEnabled ?? this.taxEnabled,
    taxRate: taxRate ?? this.taxRate,
    ccEnabled: ccEnabled ?? this.ccEnabled,
    ccRate: ccRate ?? this.ccRate,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  PricingProfileRow copyWithCompanion(PricingProfilesCompanion data) {
    return PricingProfileRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      name: data.name.present ? data.name.value : this.name,
      laborRate: data.laborRate.present ? data.laborRate.value : this.laborRate,
      taxEnabled: data.taxEnabled.present
          ? data.taxEnabled.value
          : this.taxEnabled,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      ccEnabled: data.ccEnabled.present ? data.ccEnabled.value : this.ccEnabled,
      ccRate: data.ccRate.present ? data.ccRate.value : this.ccRate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('name: $name, ')
          ..write('laborRate: $laborRate, ')
          ..write('taxEnabled: $taxEnabled, ')
          ..write('taxRate: $taxRate, ')
          ..write('ccEnabled: $ccEnabled, ')
          ..write('ccRate: $ccRate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    name,
    laborRate,
    taxEnabled,
    taxRate,
    ccEnabled,
    ccRate,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PricingProfileRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.name == this.name &&
          other.laborRate == this.laborRate &&
          other.taxEnabled == this.taxEnabled &&
          other.taxRate == this.taxRate &&
          other.ccEnabled == this.ccEnabled &&
          other.ccRate == this.ccRate &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class PricingProfilesCompanion extends UpdateCompanion<PricingProfileRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> name;
  final Value<double> laborRate;
  final Value<bool> taxEnabled;
  final Value<double> taxRate;
  final Value<bool> ccEnabled;
  final Value<double> ccRate;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const PricingProfilesCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.name = const Value.absent(),
    this.laborRate = const Value.absent(),
    this.taxEnabled = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.ccEnabled = const Value.absent(),
    this.ccRate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PricingProfilesCompanion.insert({
    required String id,
    required String orgId,
    required String name,
    this.laborRate = const Value.absent(),
    this.taxEnabled = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.ccEnabled = const Value.absent(),
    this.ccRate = const Value.absent(),
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       name = Value(name),
       updatedAt = Value(updatedAt);
  static Insertable<PricingProfileRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? name,
    Expression<double>? laborRate,
    Expression<bool>? taxEnabled,
    Expression<double>? taxRate,
    Expression<bool>? ccEnabled,
    Expression<double>? ccRate,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (name != null) 'name': name,
      if (laborRate != null) 'labor_rate': laborRate,
      if (taxEnabled != null) 'tax_enabled': taxEnabled,
      if (taxRate != null) 'tax_rate': taxRate,
      if (ccEnabled != null) 'cc_enabled': ccEnabled,
      if (ccRate != null) 'cc_rate': ccRate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PricingProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? name,
    Value<double>? laborRate,
    Value<bool>? taxEnabled,
    Value<double>? taxRate,
    Value<bool>? ccEnabled,
    Value<double>? ccRate,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return PricingProfilesCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      laborRate: laborRate ?? this.laborRate,
      taxEnabled: taxEnabled ?? this.taxEnabled,
      taxRate: taxRate ?? this.taxRate,
      ccEnabled: ccEnabled ?? this.ccEnabled,
      ccRate: ccRate ?? this.ccRate,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (laborRate.present) {
      map['labor_rate'] = Variable<double>(laborRate.value);
    }
    if (taxEnabled.present) {
      map['tax_enabled'] = Variable<bool>(taxEnabled.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (ccEnabled.present) {
      map['cc_enabled'] = Variable<bool>(ccEnabled.value);
    }
    if (ccRate.present) {
      map['cc_rate'] = Variable<double>(ccRate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfilesCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('name: $name, ')
          ..write('laborRate: $laborRate, ')
          ..write('taxEnabled: $taxEnabled, ')
          ..write('taxRate: $taxRate, ')
          ..write('ccEnabled: $ccEnabled, ')
          ..write('ccRate: $ccRate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PricingProfileServiceTypesTable extends PricingProfileServiceTypes
    with
        TableInfo<
          $PricingProfileServiceTypesTable,
          PricingProfileServiceTypeRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricingProfileServiceTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowMeta = const VerificationMeta('row');
  @override
  late final GeneratedColumn<int> row = GeneratedColumn<int>(
    'row',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _pricePerSqFtMeta = const VerificationMeta(
    'pricePerSqFt',
  );
  @override
  late final GeneratedColumn<double> pricePerSqFt = GeneratedColumn<double>(
    'price_per_sq_ft',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _multiplierMeta = const VerificationMeta(
    'multiplier',
  );
  @override
  late final GeneratedColumn<double> multiplier = GeneratedColumn<double>(
    'multiplier',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    profileId,
    row,
    category,
    serviceType,
    description,
    pricePerSqFt,
    multiplier,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pricing_profile_service_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<PricingProfileServiceTypeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('row')) {
      context.handle(
        _rowMeta,
        row.isAcceptableOrUnknown(data['row']!, _rowMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('price_per_sq_ft')) {
      context.handle(
        _pricePerSqFtMeta,
        pricePerSqFt.isAcceptableOrUnknown(
          data['price_per_sq_ft']!,
          _pricePerSqFtMeta,
        ),
      );
    }
    if (data.containsKey('multiplier')) {
      context.handle(
        _multiplierMeta,
        multiplier.isAcceptableOrUnknown(data['multiplier']!, _multiplierMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PricingProfileServiceTypeRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PricingProfileServiceTypeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      row: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      pricePerSqFt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_sq_ft'],
      )!,
      multiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}multiplier'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $PricingProfileServiceTypesTable createAlias(String alias) {
    return $PricingProfileServiceTypesTable(attachedDatabase, alias);
  }
}

class PricingProfileServiceTypeRow extends DataClass
    implements Insertable<PricingProfileServiceTypeRow> {
  final String id;
  final String orgId;
  final String profileId;
  final int row;
  final String category;
  final String serviceType;
  final String description;
  final double pricePerSqFt;
  final double multiplier;
  final int updatedAt;
  final bool deleted;
  const PricingProfileServiceTypeRow({
    required this.id,
    required this.orgId,
    required this.profileId,
    required this.row,
    required this.category,
    required this.serviceType,
    required this.description,
    required this.pricePerSqFt,
    required this.multiplier,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['profile_id'] = Variable<String>(profileId);
    map['row'] = Variable<int>(row);
    map['category'] = Variable<String>(category);
    map['service_type'] = Variable<String>(serviceType);
    map['description'] = Variable<String>(description);
    map['price_per_sq_ft'] = Variable<double>(pricePerSqFt);
    map['multiplier'] = Variable<double>(multiplier);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  PricingProfileServiceTypesCompanion toCompanion(bool nullToAbsent) {
    return PricingProfileServiceTypesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      profileId: Value(profileId),
      row: Value(row),
      category: Value(category),
      serviceType: Value(serviceType),
      description: Value(description),
      pricePerSqFt: Value(pricePerSqFt),
      multiplier: Value(multiplier),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory PricingProfileServiceTypeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PricingProfileServiceTypeRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      row: serializer.fromJson<int>(json['row']),
      category: serializer.fromJson<String>(json['category']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      description: serializer.fromJson<String>(json['description']),
      pricePerSqFt: serializer.fromJson<double>(json['pricePerSqFt']),
      multiplier: serializer.fromJson<double>(json['multiplier']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'profileId': serializer.toJson<String>(profileId),
      'row': serializer.toJson<int>(row),
      'category': serializer.toJson<String>(category),
      'serviceType': serializer.toJson<String>(serviceType),
      'description': serializer.toJson<String>(description),
      'pricePerSqFt': serializer.toJson<double>(pricePerSqFt),
      'multiplier': serializer.toJson<double>(multiplier),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  PricingProfileServiceTypeRow copyWith({
    String? id,
    String? orgId,
    String? profileId,
    int? row,
    String? category,
    String? serviceType,
    String? description,
    double? pricePerSqFt,
    double? multiplier,
    int? updatedAt,
    bool? deleted,
  }) => PricingProfileServiceTypeRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    profileId: profileId ?? this.profileId,
    row: row ?? this.row,
    category: category ?? this.category,
    serviceType: serviceType ?? this.serviceType,
    description: description ?? this.description,
    pricePerSqFt: pricePerSqFt ?? this.pricePerSqFt,
    multiplier: multiplier ?? this.multiplier,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  PricingProfileServiceTypeRow copyWithCompanion(
    PricingProfileServiceTypesCompanion data,
  ) {
    return PricingProfileServiceTypeRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      row: data.row.present ? data.row.value : this.row,
      category: data.category.present ? data.category.value : this.category,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      description: data.description.present
          ? data.description.value
          : this.description,
      pricePerSqFt: data.pricePerSqFt.present
          ? data.pricePerSqFt.value
          : this.pricePerSqFt,
      multiplier: data.multiplier.present
          ? data.multiplier.value
          : this.multiplier,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileServiceTypeRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('row: $row, ')
          ..write('category: $category, ')
          ..write('serviceType: $serviceType, ')
          ..write('description: $description, ')
          ..write('pricePerSqFt: $pricePerSqFt, ')
          ..write('multiplier: $multiplier, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    profileId,
    row,
    category,
    serviceType,
    description,
    pricePerSqFt,
    multiplier,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PricingProfileServiceTypeRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.profileId == this.profileId &&
          other.row == this.row &&
          other.category == this.category &&
          other.serviceType == this.serviceType &&
          other.description == this.description &&
          other.pricePerSqFt == this.pricePerSqFt &&
          other.multiplier == this.multiplier &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class PricingProfileServiceTypesCompanion
    extends UpdateCompanion<PricingProfileServiceTypeRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> profileId;
  final Value<int> row;
  final Value<String> category;
  final Value<String> serviceType;
  final Value<String> description;
  final Value<double> pricePerSqFt;
  final Value<double> multiplier;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const PricingProfileServiceTypesCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.row = const Value.absent(),
    this.category = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.description = const Value.absent(),
    this.pricePerSqFt = const Value.absent(),
    this.multiplier = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PricingProfileServiceTypesCompanion.insert({
    required String id,
    required String orgId,
    required String profileId,
    this.row = const Value.absent(),
    this.category = const Value.absent(),
    required String serviceType,
    this.description = const Value.absent(),
    this.pricePerSqFt = const Value.absent(),
    this.multiplier = const Value.absent(),
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       profileId = Value(profileId),
       serviceType = Value(serviceType),
       updatedAt = Value(updatedAt);
  static Insertable<PricingProfileServiceTypeRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? profileId,
    Expression<int>? row,
    Expression<String>? category,
    Expression<String>? serviceType,
    Expression<String>? description,
    Expression<double>? pricePerSqFt,
    Expression<double>? multiplier,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (profileId != null) 'profile_id': profileId,
      if (row != null) 'row': row,
      if (category != null) 'category': category,
      if (serviceType != null) 'service_type': serviceType,
      if (description != null) 'description': description,
      if (pricePerSqFt != null) 'price_per_sq_ft': pricePerSqFt,
      if (multiplier != null) 'multiplier': multiplier,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PricingProfileServiceTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? profileId,
    Value<int>? row,
    Value<String>? category,
    Value<String>? serviceType,
    Value<String>? description,
    Value<double>? pricePerSqFt,
    Value<double>? multiplier,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return PricingProfileServiceTypesCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      profileId: profileId ?? this.profileId,
      row: row ?? this.row,
      category: category ?? this.category,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      pricePerSqFt: pricePerSqFt ?? this.pricePerSqFt,
      multiplier: multiplier ?? this.multiplier,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (row.present) {
      map['row'] = Variable<int>(row.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (pricePerSqFt.present) {
      map['price_per_sq_ft'] = Variable<double>(pricePerSqFt.value);
    }
    if (multiplier.present) {
      map['multiplier'] = Variable<double>(multiplier.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileServiceTypesCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('row: $row, ')
          ..write('category: $category, ')
          ..write('serviceType: $serviceType, ')
          ..write('description: $description, ')
          ..write('pricePerSqFt: $pricePerSqFt, ')
          ..write('multiplier: $multiplier, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PricingProfileFrequenciesTable extends PricingProfileFrequencies
    with
        TableInfo<$PricingProfileFrequenciesTable, PricingProfileFrequencyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricingProfileFrequenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _multiplierMeta = const VerificationMeta(
    'multiplier',
  );
  @override
  late final GeneratedColumn<double> multiplier = GeneratedColumn<double>(
    'multiplier',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    profileId,
    serviceType,
    frequency,
    multiplier,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pricing_profile_frequencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<PricingProfileFrequencyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceTypeMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('multiplier')) {
      context.handle(
        _multiplierMeta,
        multiplier.isAcceptableOrUnknown(data['multiplier']!, _multiplierMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PricingProfileFrequencyRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PricingProfileFrequencyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      multiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}multiplier'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $PricingProfileFrequenciesTable createAlias(String alias) {
    return $PricingProfileFrequenciesTable(attachedDatabase, alias);
  }
}

class PricingProfileFrequencyRow extends DataClass
    implements Insertable<PricingProfileFrequencyRow> {
  final String id;
  final String orgId;
  final String profileId;
  final String serviceType;
  final String frequency;
  final double multiplier;
  final int updatedAt;
  final bool deleted;
  const PricingProfileFrequencyRow({
    required this.id,
    required this.orgId,
    required this.profileId,
    required this.serviceType,
    required this.frequency,
    required this.multiplier,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['profile_id'] = Variable<String>(profileId);
    map['service_type'] = Variable<String>(serviceType);
    map['frequency'] = Variable<String>(frequency);
    map['multiplier'] = Variable<double>(multiplier);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  PricingProfileFrequenciesCompanion toCompanion(bool nullToAbsent) {
    return PricingProfileFrequenciesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      profileId: Value(profileId),
      serviceType: Value(serviceType),
      frequency: Value(frequency),
      multiplier: Value(multiplier),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory PricingProfileFrequencyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PricingProfileFrequencyRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      frequency: serializer.fromJson<String>(json['frequency']),
      multiplier: serializer.fromJson<double>(json['multiplier']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'profileId': serializer.toJson<String>(profileId),
      'serviceType': serializer.toJson<String>(serviceType),
      'frequency': serializer.toJson<String>(frequency),
      'multiplier': serializer.toJson<double>(multiplier),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  PricingProfileFrequencyRow copyWith({
    String? id,
    String? orgId,
    String? profileId,
    String? serviceType,
    String? frequency,
    double? multiplier,
    int? updatedAt,
    bool? deleted,
  }) => PricingProfileFrequencyRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    profileId: profileId ?? this.profileId,
    serviceType: serviceType ?? this.serviceType,
    frequency: frequency ?? this.frequency,
    multiplier: multiplier ?? this.multiplier,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  PricingProfileFrequencyRow copyWithCompanion(
    PricingProfileFrequenciesCompanion data,
  ) {
    return PricingProfileFrequencyRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      multiplier: data.multiplier.present
          ? data.multiplier.value
          : this.multiplier,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileFrequencyRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('serviceType: $serviceType, ')
          ..write('frequency: $frequency, ')
          ..write('multiplier: $multiplier, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    profileId,
    serviceType,
    frequency,
    multiplier,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PricingProfileFrequencyRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.profileId == this.profileId &&
          other.serviceType == this.serviceType &&
          other.frequency == this.frequency &&
          other.multiplier == this.multiplier &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class PricingProfileFrequenciesCompanion
    extends UpdateCompanion<PricingProfileFrequencyRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> profileId;
  final Value<String> serviceType;
  final Value<String> frequency;
  final Value<double> multiplier;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const PricingProfileFrequenciesCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.frequency = const Value.absent(),
    this.multiplier = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PricingProfileFrequenciesCompanion.insert({
    required String id,
    required String orgId,
    required String profileId,
    required String serviceType,
    required String frequency,
    this.multiplier = const Value.absent(),
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       profileId = Value(profileId),
       serviceType = Value(serviceType),
       frequency = Value(frequency),
       updatedAt = Value(updatedAt);
  static Insertable<PricingProfileFrequencyRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? profileId,
    Expression<String>? serviceType,
    Expression<String>? frequency,
    Expression<double>? multiplier,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (profileId != null) 'profile_id': profileId,
      if (serviceType != null) 'service_type': serviceType,
      if (frequency != null) 'frequency': frequency,
      if (multiplier != null) 'multiplier': multiplier,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PricingProfileFrequenciesCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? profileId,
    Value<String>? serviceType,
    Value<String>? frequency,
    Value<double>? multiplier,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return PricingProfileFrequenciesCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      profileId: profileId ?? this.profileId,
      serviceType: serviceType ?? this.serviceType,
      frequency: frequency ?? this.frequency,
      multiplier: multiplier ?? this.multiplier,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (multiplier.present) {
      map['multiplier'] = Variable<double>(multiplier.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileFrequenciesCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('serviceType: $serviceType, ')
          ..write('frequency: $frequency, ')
          ..write('multiplier: $multiplier, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PricingProfileRoomTypesTable extends PricingProfileRoomTypes
    with TableInfo<$PricingProfileRoomTypesTable, PricingProfileRoomTypeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricingProfileRoomTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowMeta = const VerificationMeta('row');
  @override
  late final GeneratedColumn<int> row = GeneratedColumn<int>(
    'row',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _roomTypeMeta = const VerificationMeta(
    'roomType',
  );
  @override
  late final GeneratedColumn<String> roomType = GeneratedColumn<String>(
    'room_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _squareFeetMeta = const VerificationMeta(
    'squareFeet',
  );
  @override
  late final GeneratedColumn<int> squareFeet = GeneratedColumn<int>(
    'square_feet',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    profileId,
    row,
    category,
    roomType,
    description,
    minutes,
    squareFeet,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pricing_profile_room_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<PricingProfileRoomTypeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('row')) {
      context.handle(
        _rowMeta,
        row.isAcceptableOrUnknown(data['row']!, _rowMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('room_type')) {
      context.handle(
        _roomTypeMeta,
        roomType.isAcceptableOrUnknown(data['room_type']!, _roomTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_roomTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('square_feet')) {
      context.handle(
        _squareFeetMeta,
        squareFeet.isAcceptableOrUnknown(data['square_feet']!, _squareFeetMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PricingProfileRoomTypeRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PricingProfileRoomTypeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      row: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      roomType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      squareFeet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}square_feet'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $PricingProfileRoomTypesTable createAlias(String alias) {
    return $PricingProfileRoomTypesTable(attachedDatabase, alias);
  }
}

class PricingProfileRoomTypeRow extends DataClass
    implements Insertable<PricingProfileRoomTypeRow> {
  final String id;
  final String orgId;
  final String profileId;
  final int row;
  final String category;
  final String roomType;
  final String description;
  final int minutes;
  final int squareFeet;
  final int updatedAt;
  final bool deleted;
  const PricingProfileRoomTypeRow({
    required this.id,
    required this.orgId,
    required this.profileId,
    required this.row,
    required this.category,
    required this.roomType,
    required this.description,
    required this.minutes,
    required this.squareFeet,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['profile_id'] = Variable<String>(profileId);
    map['row'] = Variable<int>(row);
    map['category'] = Variable<String>(category);
    map['room_type'] = Variable<String>(roomType);
    map['description'] = Variable<String>(description);
    map['minutes'] = Variable<int>(minutes);
    map['square_feet'] = Variable<int>(squareFeet);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  PricingProfileRoomTypesCompanion toCompanion(bool nullToAbsent) {
    return PricingProfileRoomTypesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      profileId: Value(profileId),
      row: Value(row),
      category: Value(category),
      roomType: Value(roomType),
      description: Value(description),
      minutes: Value(minutes),
      squareFeet: Value(squareFeet),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory PricingProfileRoomTypeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PricingProfileRoomTypeRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      row: serializer.fromJson<int>(json['row']),
      category: serializer.fromJson<String>(json['category']),
      roomType: serializer.fromJson<String>(json['roomType']),
      description: serializer.fromJson<String>(json['description']),
      minutes: serializer.fromJson<int>(json['minutes']),
      squareFeet: serializer.fromJson<int>(json['squareFeet']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'profileId': serializer.toJson<String>(profileId),
      'row': serializer.toJson<int>(row),
      'category': serializer.toJson<String>(category),
      'roomType': serializer.toJson<String>(roomType),
      'description': serializer.toJson<String>(description),
      'minutes': serializer.toJson<int>(minutes),
      'squareFeet': serializer.toJson<int>(squareFeet),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  PricingProfileRoomTypeRow copyWith({
    String? id,
    String? orgId,
    String? profileId,
    int? row,
    String? category,
    String? roomType,
    String? description,
    int? minutes,
    int? squareFeet,
    int? updatedAt,
    bool? deleted,
  }) => PricingProfileRoomTypeRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    profileId: profileId ?? this.profileId,
    row: row ?? this.row,
    category: category ?? this.category,
    roomType: roomType ?? this.roomType,
    description: description ?? this.description,
    minutes: minutes ?? this.minutes,
    squareFeet: squareFeet ?? this.squareFeet,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  PricingProfileRoomTypeRow copyWithCompanion(
    PricingProfileRoomTypesCompanion data,
  ) {
    return PricingProfileRoomTypeRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      row: data.row.present ? data.row.value : this.row,
      category: data.category.present ? data.category.value : this.category,
      roomType: data.roomType.present ? data.roomType.value : this.roomType,
      description: data.description.present
          ? data.description.value
          : this.description,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      squareFeet: data.squareFeet.present
          ? data.squareFeet.value
          : this.squareFeet,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileRoomTypeRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('row: $row, ')
          ..write('category: $category, ')
          ..write('roomType: $roomType, ')
          ..write('description: $description, ')
          ..write('minutes: $minutes, ')
          ..write('squareFeet: $squareFeet, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    profileId,
    row,
    category,
    roomType,
    description,
    minutes,
    squareFeet,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PricingProfileRoomTypeRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.profileId == this.profileId &&
          other.row == this.row &&
          other.category == this.category &&
          other.roomType == this.roomType &&
          other.description == this.description &&
          other.minutes == this.minutes &&
          other.squareFeet == this.squareFeet &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class PricingProfileRoomTypesCompanion
    extends UpdateCompanion<PricingProfileRoomTypeRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> profileId;
  final Value<int> row;
  final Value<String> category;
  final Value<String> roomType;
  final Value<String> description;
  final Value<int> minutes;
  final Value<int> squareFeet;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const PricingProfileRoomTypesCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.row = const Value.absent(),
    this.category = const Value.absent(),
    this.roomType = const Value.absent(),
    this.description = const Value.absent(),
    this.minutes = const Value.absent(),
    this.squareFeet = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PricingProfileRoomTypesCompanion.insert({
    required String id,
    required String orgId,
    required String profileId,
    this.row = const Value.absent(),
    this.category = const Value.absent(),
    required String roomType,
    this.description = const Value.absent(),
    this.minutes = const Value.absent(),
    this.squareFeet = const Value.absent(),
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       profileId = Value(profileId),
       roomType = Value(roomType),
       updatedAt = Value(updatedAt);
  static Insertable<PricingProfileRoomTypeRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? profileId,
    Expression<int>? row,
    Expression<String>? category,
    Expression<String>? roomType,
    Expression<String>? description,
    Expression<int>? minutes,
    Expression<int>? squareFeet,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (profileId != null) 'profile_id': profileId,
      if (row != null) 'row': row,
      if (category != null) 'category': category,
      if (roomType != null) 'room_type': roomType,
      if (description != null) 'description': description,
      if (minutes != null) 'minutes': minutes,
      if (squareFeet != null) 'square_feet': squareFeet,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PricingProfileRoomTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? profileId,
    Value<int>? row,
    Value<String>? category,
    Value<String>? roomType,
    Value<String>? description,
    Value<int>? minutes,
    Value<int>? squareFeet,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return PricingProfileRoomTypesCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      profileId: profileId ?? this.profileId,
      row: row ?? this.row,
      category: category ?? this.category,
      roomType: roomType ?? this.roomType,
      description: description ?? this.description,
      minutes: minutes ?? this.minutes,
      squareFeet: squareFeet ?? this.squareFeet,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (row.present) {
      map['row'] = Variable<int>(row.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (roomType.present) {
      map['room_type'] = Variable<String>(roomType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (squareFeet.present) {
      map['square_feet'] = Variable<int>(squareFeet.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileRoomTypesCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('row: $row, ')
          ..write('category: $category, ')
          ..write('roomType: $roomType, ')
          ..write('description: $description, ')
          ..write('minutes: $minutes, ')
          ..write('squareFeet: $squareFeet, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PricingProfileSubItemsTable extends PricingProfileSubItems
    with TableInfo<$PricingProfileSubItemsTable, PricingProfileSubItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricingProfileSubItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _subItemMeta = const VerificationMeta(
    'subItem',
  );
  @override
  late final GeneratedColumn<String> subItem = GeneratedColumn<String>(
    'sub_item',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    profileId,
    category,
    subItem,
    description,
    minutes,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pricing_profile_sub_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PricingProfileSubItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('sub_item')) {
      context.handle(
        _subItemMeta,
        subItem.isAcceptableOrUnknown(data['sub_item']!, _subItemMeta),
      );
    } else if (isInserting) {
      context.missing(_subItemMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PricingProfileSubItemRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PricingProfileSubItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      subItem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_item'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $PricingProfileSubItemsTable createAlias(String alias) {
    return $PricingProfileSubItemsTable(attachedDatabase, alias);
  }
}

class PricingProfileSubItemRow extends DataClass
    implements Insertable<PricingProfileSubItemRow> {
  final String id;
  final String orgId;
  final String profileId;
  final String category;
  final String subItem;
  final String description;
  final int minutes;
  final int updatedAt;
  final bool deleted;
  const PricingProfileSubItemRow({
    required this.id,
    required this.orgId,
    required this.profileId,
    required this.category,
    required this.subItem,
    required this.description,
    required this.minutes,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['profile_id'] = Variable<String>(profileId);
    map['category'] = Variable<String>(category);
    map['sub_item'] = Variable<String>(subItem);
    map['description'] = Variable<String>(description);
    map['minutes'] = Variable<int>(minutes);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  PricingProfileSubItemsCompanion toCompanion(bool nullToAbsent) {
    return PricingProfileSubItemsCompanion(
      id: Value(id),
      orgId: Value(orgId),
      profileId: Value(profileId),
      category: Value(category),
      subItem: Value(subItem),
      description: Value(description),
      minutes: Value(minutes),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory PricingProfileSubItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PricingProfileSubItemRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      category: serializer.fromJson<String>(json['category']),
      subItem: serializer.fromJson<String>(json['subItem']),
      description: serializer.fromJson<String>(json['description']),
      minutes: serializer.fromJson<int>(json['minutes']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'profileId': serializer.toJson<String>(profileId),
      'category': serializer.toJson<String>(category),
      'subItem': serializer.toJson<String>(subItem),
      'description': serializer.toJson<String>(description),
      'minutes': serializer.toJson<int>(minutes),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  PricingProfileSubItemRow copyWith({
    String? id,
    String? orgId,
    String? profileId,
    String? category,
    String? subItem,
    String? description,
    int? minutes,
    int? updatedAt,
    bool? deleted,
  }) => PricingProfileSubItemRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    profileId: profileId ?? this.profileId,
    category: category ?? this.category,
    subItem: subItem ?? this.subItem,
    description: description ?? this.description,
    minutes: minutes ?? this.minutes,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  PricingProfileSubItemRow copyWithCompanion(
    PricingProfileSubItemsCompanion data,
  ) {
    return PricingProfileSubItemRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      category: data.category.present ? data.category.value : this.category,
      subItem: data.subItem.present ? data.subItem.value : this.subItem,
      description: data.description.present
          ? data.description.value
          : this.description,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileSubItemRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('category: $category, ')
          ..write('subItem: $subItem, ')
          ..write('description: $description, ')
          ..write('minutes: $minutes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    profileId,
    category,
    subItem,
    description,
    minutes,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PricingProfileSubItemRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.profileId == this.profileId &&
          other.category == this.category &&
          other.subItem == this.subItem &&
          other.description == this.description &&
          other.minutes == this.minutes &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class PricingProfileSubItemsCompanion
    extends UpdateCompanion<PricingProfileSubItemRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> profileId;
  final Value<String> category;
  final Value<String> subItem;
  final Value<String> description;
  final Value<int> minutes;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const PricingProfileSubItemsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.category = const Value.absent(),
    this.subItem = const Value.absent(),
    this.description = const Value.absent(),
    this.minutes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PricingProfileSubItemsCompanion.insert({
    required String id,
    required String orgId,
    required String profileId,
    this.category = const Value.absent(),
    required String subItem,
    this.description = const Value.absent(),
    this.minutes = const Value.absent(),
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       profileId = Value(profileId),
       subItem = Value(subItem),
       updatedAt = Value(updatedAt);
  static Insertable<PricingProfileSubItemRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? profileId,
    Expression<String>? category,
    Expression<String>? subItem,
    Expression<String>? description,
    Expression<int>? minutes,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (profileId != null) 'profile_id': profileId,
      if (category != null) 'category': category,
      if (subItem != null) 'sub_item': subItem,
      if (description != null) 'description': description,
      if (minutes != null) 'minutes': minutes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PricingProfileSubItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? profileId,
    Value<String>? category,
    Value<String>? subItem,
    Value<String>? description,
    Value<int>? minutes,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return PricingProfileSubItemsCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      profileId: profileId ?? this.profileId,
      category: category ?? this.category,
      subItem: subItem ?? this.subItem,
      description: description ?? this.description,
      minutes: minutes ?? this.minutes,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subItem.present) {
      map['sub_item'] = Variable<String>(subItem.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileSubItemsCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('category: $category, ')
          ..write('subItem: $subItem, ')
          ..write('description: $description, ')
          ..write('minutes: $minutes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PricingProfileSizesTable extends PricingProfileSizes
    with TableInfo<$PricingProfileSizesTable, PricingProfileSizeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricingProfileSizesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<String> size = GeneratedColumn<String>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _multiplierMeta = const VerificationMeta(
    'multiplier',
  );
  @override
  late final GeneratedColumn<double> multiplier = GeneratedColumn<double>(
    'multiplier',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _definitionMeta = const VerificationMeta(
    'definition',
  );
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
    'definition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    profileId,
    size,
    multiplier,
    definition,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pricing_profile_sizes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PricingProfileSizeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('multiplier')) {
      context.handle(
        _multiplierMeta,
        multiplier.isAcceptableOrUnknown(data['multiplier']!, _multiplierMeta),
      );
    }
    if (data.containsKey('definition')) {
      context.handle(
        _definitionMeta,
        definition.isAcceptableOrUnknown(data['definition']!, _definitionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PricingProfileSizeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PricingProfileSizeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}size'],
      )!,
      multiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}multiplier'],
      )!,
      definition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $PricingProfileSizesTable createAlias(String alias) {
    return $PricingProfileSizesTable(attachedDatabase, alias);
  }
}

class PricingProfileSizeRow extends DataClass
    implements Insertable<PricingProfileSizeRow> {
  final String id;
  final String orgId;
  final String profileId;
  final String size;
  final double multiplier;
  final String definition;
  final int updatedAt;
  final bool deleted;
  const PricingProfileSizeRow({
    required this.id,
    required this.orgId,
    required this.profileId,
    required this.size,
    required this.multiplier,
    required this.definition,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['profile_id'] = Variable<String>(profileId);
    map['size'] = Variable<String>(size);
    map['multiplier'] = Variable<double>(multiplier);
    map['definition'] = Variable<String>(definition);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  PricingProfileSizesCompanion toCompanion(bool nullToAbsent) {
    return PricingProfileSizesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      profileId: Value(profileId),
      size: Value(size),
      multiplier: Value(multiplier),
      definition: Value(definition),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory PricingProfileSizeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PricingProfileSizeRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      size: serializer.fromJson<String>(json['size']),
      multiplier: serializer.fromJson<double>(json['multiplier']),
      definition: serializer.fromJson<String>(json['definition']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'profileId': serializer.toJson<String>(profileId),
      'size': serializer.toJson<String>(size),
      'multiplier': serializer.toJson<double>(multiplier),
      'definition': serializer.toJson<String>(definition),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  PricingProfileSizeRow copyWith({
    String? id,
    String? orgId,
    String? profileId,
    String? size,
    double? multiplier,
    String? definition,
    int? updatedAt,
    bool? deleted,
  }) => PricingProfileSizeRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    profileId: profileId ?? this.profileId,
    size: size ?? this.size,
    multiplier: multiplier ?? this.multiplier,
    definition: definition ?? this.definition,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  PricingProfileSizeRow copyWithCompanion(PricingProfileSizesCompanion data) {
    return PricingProfileSizeRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      size: data.size.present ? data.size.value : this.size,
      multiplier: data.multiplier.present
          ? data.multiplier.value
          : this.multiplier,
      definition: data.definition.present
          ? data.definition.value
          : this.definition,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileSizeRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('size: $size, ')
          ..write('multiplier: $multiplier, ')
          ..write('definition: $definition, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    profileId,
    size,
    multiplier,
    definition,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PricingProfileSizeRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.profileId == this.profileId &&
          other.size == this.size &&
          other.multiplier == this.multiplier &&
          other.definition == this.definition &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class PricingProfileSizesCompanion
    extends UpdateCompanion<PricingProfileSizeRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> profileId;
  final Value<String> size;
  final Value<double> multiplier;
  final Value<String> definition;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const PricingProfileSizesCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.size = const Value.absent(),
    this.multiplier = const Value.absent(),
    this.definition = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PricingProfileSizesCompanion.insert({
    required String id,
    required String orgId,
    required String profileId,
    required String size,
    this.multiplier = const Value.absent(),
    this.definition = const Value.absent(),
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       profileId = Value(profileId),
       size = Value(size),
       updatedAt = Value(updatedAt);
  static Insertable<PricingProfileSizeRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? profileId,
    Expression<String>? size,
    Expression<double>? multiplier,
    Expression<String>? definition,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (profileId != null) 'profile_id': profileId,
      if (size != null) 'size': size,
      if (multiplier != null) 'multiplier': multiplier,
      if (definition != null) 'definition': definition,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PricingProfileSizesCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? profileId,
    Value<String>? size,
    Value<double>? multiplier,
    Value<String>? definition,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return PricingProfileSizesCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      profileId: profileId ?? this.profileId,
      size: size ?? this.size,
      multiplier: multiplier ?? this.multiplier,
      definition: definition ?? this.definition,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (size.present) {
      map['size'] = Variable<String>(size.value);
    }
    if (multiplier.present) {
      map['multiplier'] = Variable<double>(multiplier.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileSizesCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('size: $size, ')
          ..write('multiplier: $multiplier, ')
          ..write('definition: $definition, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PricingProfileComplexitiesTable extends PricingProfileComplexities
    with
        TableInfo<
          $PricingProfileComplexitiesTable,
          PricingProfileComplexityRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricingProfileComplexitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _multiplierMeta = const VerificationMeta(
    'multiplier',
  );
  @override
  late final GeneratedColumn<double> multiplier = GeneratedColumn<double>(
    'multiplier',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _definitionMeta = const VerificationMeta(
    'definition',
  );
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
    'definition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    profileId,
    level,
    multiplier,
    definition,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pricing_profile_complexities';
  @override
  VerificationContext validateIntegrity(
    Insertable<PricingProfileComplexityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('multiplier')) {
      context.handle(
        _multiplierMeta,
        multiplier.isAcceptableOrUnknown(data['multiplier']!, _multiplierMeta),
      );
    }
    if (data.containsKey('definition')) {
      context.handle(
        _definitionMeta,
        definition.isAcceptableOrUnknown(data['definition']!, _definitionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PricingProfileComplexityRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PricingProfileComplexityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      multiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}multiplier'],
      )!,
      definition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $PricingProfileComplexitiesTable createAlias(String alias) {
    return $PricingProfileComplexitiesTable(attachedDatabase, alias);
  }
}

class PricingProfileComplexityRow extends DataClass
    implements Insertable<PricingProfileComplexityRow> {
  final String id;
  final String orgId;
  final String profileId;
  final String level;
  final double multiplier;
  final String definition;
  final int updatedAt;
  final bool deleted;
  const PricingProfileComplexityRow({
    required this.id,
    required this.orgId,
    required this.profileId,
    required this.level,
    required this.multiplier,
    required this.definition,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['profile_id'] = Variable<String>(profileId);
    map['level'] = Variable<String>(level);
    map['multiplier'] = Variable<double>(multiplier);
    map['definition'] = Variable<String>(definition);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  PricingProfileComplexitiesCompanion toCompanion(bool nullToAbsent) {
    return PricingProfileComplexitiesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      profileId: Value(profileId),
      level: Value(level),
      multiplier: Value(multiplier),
      definition: Value(definition),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory PricingProfileComplexityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PricingProfileComplexityRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      level: serializer.fromJson<String>(json['level']),
      multiplier: serializer.fromJson<double>(json['multiplier']),
      definition: serializer.fromJson<String>(json['definition']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'profileId': serializer.toJson<String>(profileId),
      'level': serializer.toJson<String>(level),
      'multiplier': serializer.toJson<double>(multiplier),
      'definition': serializer.toJson<String>(definition),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  PricingProfileComplexityRow copyWith({
    String? id,
    String? orgId,
    String? profileId,
    String? level,
    double? multiplier,
    String? definition,
    int? updatedAt,
    bool? deleted,
  }) => PricingProfileComplexityRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    profileId: profileId ?? this.profileId,
    level: level ?? this.level,
    multiplier: multiplier ?? this.multiplier,
    definition: definition ?? this.definition,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  PricingProfileComplexityRow copyWithCompanion(
    PricingProfileComplexitiesCompanion data,
  ) {
    return PricingProfileComplexityRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      level: data.level.present ? data.level.value : this.level,
      multiplier: data.multiplier.present
          ? data.multiplier.value
          : this.multiplier,
      definition: data.definition.present
          ? data.definition.value
          : this.definition,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileComplexityRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('level: $level, ')
          ..write('multiplier: $multiplier, ')
          ..write('definition: $definition, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    profileId,
    level,
    multiplier,
    definition,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PricingProfileComplexityRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.profileId == this.profileId &&
          other.level == this.level &&
          other.multiplier == this.multiplier &&
          other.definition == this.definition &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class PricingProfileComplexitiesCompanion
    extends UpdateCompanion<PricingProfileComplexityRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> profileId;
  final Value<String> level;
  final Value<double> multiplier;
  final Value<String> definition;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const PricingProfileComplexitiesCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.level = const Value.absent(),
    this.multiplier = const Value.absent(),
    this.definition = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PricingProfileComplexitiesCompanion.insert({
    required String id,
    required String orgId,
    required String profileId,
    required String level,
    this.multiplier = const Value.absent(),
    this.definition = const Value.absent(),
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       profileId = Value(profileId),
       level = Value(level),
       updatedAt = Value(updatedAt);
  static Insertable<PricingProfileComplexityRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? profileId,
    Expression<String>? level,
    Expression<double>? multiplier,
    Expression<String>? definition,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (profileId != null) 'profile_id': profileId,
      if (level != null) 'level': level,
      if (multiplier != null) 'multiplier': multiplier,
      if (definition != null) 'definition': definition,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PricingProfileComplexitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? profileId,
    Value<String>? level,
    Value<double>? multiplier,
    Value<String>? definition,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return PricingProfileComplexitiesCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      profileId: profileId ?? this.profileId,
      level: level ?? this.level,
      multiplier: multiplier ?? this.multiplier,
      definition: definition ?? this.definition,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (multiplier.present) {
      map['multiplier'] = Variable<double>(multiplier.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricingProfileComplexitiesCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('profileId: $profileId, ')
          ..write('level: $level, ')
          ..write('multiplier: $multiplier, ')
          ..write('definition: $definition, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opTypeMeta = const VerificationMeta('opType');
  @override
  late final GeneratedColumn<String> opType = GeneratedColumn<String>(
    'op_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    opType,
    payload,
    updatedAt,
    orgId,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op_type')) {
      context.handle(
        _opTypeMeta,
        opType.isAcceptableOrUnknown(data['op_type']!, _opTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_opTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      opType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final String id;
  final String entityType;
  final String entityId;
  final String opType;
  final String payload;
  final int updatedAt;
  final String orgId;
  final String status;
  const OutboxRow({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.opType,
    required this.payload,
    required this.updatedAt,
    required this.orgId,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['op_type'] = Variable<String>(opType);
    map['payload'] = Variable<String>(payload);
    map['updated_at'] = Variable<int>(updatedAt);
    map['org_id'] = Variable<String>(orgId);
    map['status'] = Variable<String>(status);
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      opType: Value(opType),
      payload: Value(payload),
      updatedAt: Value(updatedAt),
      orgId: Value(orgId),
      status: Value(status),
    );
  }

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      opType: serializer.fromJson<String>(json['opType']),
      payload: serializer.fromJson<String>(json['payload']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      orgId: serializer.fromJson<String>(json['orgId']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'opType': serializer.toJson<String>(opType),
      'payload': serializer.toJson<String>(payload),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'orgId': serializer.toJson<String>(orgId),
      'status': serializer.toJson<String>(status),
    };
  }

  OutboxRow copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? opType,
    String? payload,
    int? updatedAt,
    String? orgId,
    String? status,
  }) => OutboxRow(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    opType: opType ?? this.opType,
    payload: payload ?? this.payload,
    updatedAt: updatedAt ?? this.updatedAt,
    orgId: orgId ?? this.orgId,
    status: status ?? this.status,
  );
  OutboxRow copyWithCompanion(OutboxCompanion data) {
    return OutboxRow(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      opType: data.opType.present ? data.opType.value : this.opType,
      payload: data.payload.present ? data.payload.value : this.payload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('opType: $opType, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('orgId: $orgId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    opType,
    payload,
    updatedAt,
    orgId,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.opType == this.opType &&
          other.payload == this.payload &&
          other.updatedAt == this.updatedAt &&
          other.orgId == this.orgId &&
          other.status == this.status);
}

class OutboxCompanion extends UpdateCompanion<OutboxRow> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> opType;
  final Value<String> payload;
  final Value<int> updatedAt;
  final Value<String> orgId;
  final Value<String> status;
  final Value<int> rowid;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.opType = const Value.absent(),
    this.payload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.orgId = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String opType,
    required String payload,
    required int updatedAt,
    required String orgId,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       opType = Value(opType),
       payload = Value(payload),
       updatedAt = Value(updatedAt),
       orgId = Value(orgId);
  static Insertable<OutboxRow> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? opType,
    Expression<String>? payload,
    Expression<int>? updatedAt,
    Expression<String>? orgId,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (opType != null) 'op_type': opType,
      if (payload != null) 'payload': payload,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (orgId != null) 'org_id': orgId,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? opType,
    Value<String>? payload,
    Value<int>? updatedAt,
    Value<String>? orgId,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      opType: opType ?? this.opType,
      payload: payload ?? this.payload,
      updatedAt: updatedAt ?? this.updatedAt,
      orgId: orgId ?? this.orgId,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (opType.present) {
      map['op_type'] = Variable<String>(opType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('opType: $opType, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('orgId: $orgId, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<int> lastSyncAt = GeneratedColumn<int>(
    'last_sync_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, orgId, lastSyncAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, orgId};
  @override
  SyncStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_at'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateRow extends DataClass implements Insertable<SyncStateRow> {
  final String id;
  final String orgId;
  final int lastSyncAt;
  const SyncStateRow({
    required this.id,
    required this.orgId,
    required this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['last_sync_at'] = Variable<int>(lastSyncAt);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      id: Value(id),
      orgId: Value(orgId),
      lastSyncAt: Value(lastSyncAt),
    );
  }

  factory SyncStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      lastSyncAt: serializer.fromJson<int>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'lastSyncAt': serializer.toJson<int>(lastSyncAt),
    };
  }

  SyncStateRow copyWith({String? id, String? orgId, int? lastSyncAt}) =>
      SyncStateRow(
        id: id ?? this.id,
        orgId: orgId ?? this.orgId,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      );
  SyncStateRow copyWithCompanion(SyncStateCompanion data) {
    return SyncStateRow(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orgId, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateRow &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.lastSyncAt == this.lastSyncAt);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<int> lastSyncAt;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String id,
    required String orgId,
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId);
  static Insertable<SyncStateRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<int>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<int>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<int>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinalizedDocumentsTable extends FinalizedDocuments
    with TableInfo<$FinalizedDocumentsTable, FinalizedDocumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinalizedDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _docTypeMeta = const VerificationMeta(
    'docType',
  );
  @override
  late final GeneratedColumn<String> docType = GeneratedColumn<String>(
    'doc_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remotePathMeta = const VerificationMeta(
    'remotePath',
  );
  @override
  late final GeneratedColumn<String> remotePath = GeneratedColumn<String>(
    'remote_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quoteSnapshotMeta = const VerificationMeta(
    'quoteSnapshot',
  );
  @override
  late final GeneratedColumn<String> quoteSnapshot = GeneratedColumn<String>(
    'quote_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricingSnapshotMeta = const VerificationMeta(
    'pricingSnapshot',
  );
  @override
  late final GeneratedColumn<String> pricingSnapshot = GeneratedColumn<String>(
    'pricing_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalsSnapshotMeta = const VerificationMeta(
    'totalsSnapshot',
  );
  @override
  late final GeneratedColumn<String> totalsSnapshot = GeneratedColumn<String>(
    'totals_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    quoteId,
    docType,
    createdAt,
    updatedAt,
    status,
    localPath,
    remotePath,
    quoteSnapshot,
    pricingSnapshot,
    totalsSnapshot,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finalized_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinalizedDocumentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('doc_type')) {
      context.handle(
        _docTypeMeta,
        docType.isAcceptableOrUnknown(data['doc_type']!, _docTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_docTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('remote_path')) {
      context.handle(
        _remotePathMeta,
        remotePath.isAcceptableOrUnknown(data['remote_path']!, _remotePathMeta),
      );
    }
    if (data.containsKey('quote_snapshot')) {
      context.handle(
        _quoteSnapshotMeta,
        quoteSnapshot.isAcceptableOrUnknown(
          data['quote_snapshot']!,
          _quoteSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quoteSnapshotMeta);
    }
    if (data.containsKey('pricing_snapshot')) {
      context.handle(
        _pricingSnapshotMeta,
        pricingSnapshot.isAcceptableOrUnknown(
          data['pricing_snapshot']!,
          _pricingSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricingSnapshotMeta);
    }
    if (data.containsKey('totals_snapshot')) {
      context.handle(
        _totalsSnapshotMeta,
        totalsSnapshot.isAcceptableOrUnknown(
          data['totals_snapshot']!,
          _totalsSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalsSnapshotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinalizedDocumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinalizedDocumentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      docType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doc_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      remotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_path'],
      ),
      quoteSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_snapshot'],
      )!,
      pricingSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pricing_snapshot'],
      )!,
      totalsSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}totals_snapshot'],
      )!,
    );
  }

  @override
  $FinalizedDocumentsTable createAlias(String alias) {
    return $FinalizedDocumentsTable(attachedDatabase, alias);
  }
}

class FinalizedDocumentRow extends DataClass
    implements Insertable<FinalizedDocumentRow> {
  final String id;
  final String orgId;
  final String quoteId;
  final String docType;
  final int createdAt;
  final int updatedAt;
  final String status;
  final String localPath;
  final String? remotePath;
  final String quoteSnapshot;
  final String pricingSnapshot;
  final String totalsSnapshot;
  const FinalizedDocumentRow({
    required this.id,
    required this.orgId,
    required this.quoteId,
    required this.docType,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.localPath,
    this.remotePath,
    required this.quoteSnapshot,
    required this.pricingSnapshot,
    required this.totalsSnapshot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['quote_id'] = Variable<String>(quoteId);
    map['doc_type'] = Variable<String>(docType);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['status'] = Variable<String>(status);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || remotePath != null) {
      map['remote_path'] = Variable<String>(remotePath!);
    }
    map['quote_snapshot'] = Variable<String>(quoteSnapshot);
    map['pricing_snapshot'] = Variable<String>(pricingSnapshot);
    map['totals_snapshot'] = Variable<String>(totalsSnapshot);
    return map;
  }

  FinalizedDocumentsCompanion toCompanion(bool nullToAbsent) {
    return FinalizedDocumentsCompanion(
      id: Value(id),
      orgId: Value(orgId),
      quoteId: Value(quoteId),
      docType: Value(docType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      status: Value(status),
      localPath: Value(localPath),
      remotePath: remotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(remotePath),
      quoteSnapshot: Value(quoteSnapshot),
      pricingSnapshot: Value(pricingSnapshot),
      totalsSnapshot: Value(totalsSnapshot),
    );
  }

  factory FinalizedDocumentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinalizedDocumentRow(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      docType: serializer.fromJson<String>(json['docType']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      status: serializer.fromJson<String>(json['status']),
      localPath: serializer.fromJson<String>(json['localPath']),
      remotePath: serializer.fromJson<String?>(json['remotePath']),
      quoteSnapshot: serializer.fromJson<String>(json['quoteSnapshot']),
      pricingSnapshot: serializer.fromJson<String>(json['pricingSnapshot']),
      totalsSnapshot: serializer.fromJson<String>(json['totalsSnapshot']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'quoteId': serializer.toJson<String>(quoteId),
      'docType': serializer.toJson<String>(docType),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'status': serializer.toJson<String>(status),
      'localPath': serializer.toJson<String>(localPath),
      'remotePath': serializer.toJson<String?>(remotePath),
      'quoteSnapshot': serializer.toJson<String>(quoteSnapshot),
      'pricingSnapshot': serializer.toJson<String>(pricingSnapshot),
      'totalsSnapshot': serializer.toJson<String>(totalsSnapshot),
    };
  }

  FinalizedDocumentRow copyWith({
    String? id,
    String? orgId,
    String? quoteId,
    String? docType,
    int? createdAt,
    int? updatedAt,
    String? status,
    String? localPath,
    Value<String?> remotePath = const Value.absent(),
    String? quoteSnapshot,
    String? pricingSnapshot,
    String? totalsSnapshot,
  }) => FinalizedDocumentRow(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    quoteId: quoteId ?? this.quoteId,
    docType: docType ?? this.docType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    status: status ?? this.status,
    localPath: localPath ?? this.localPath,
    remotePath: remotePath.present ? remotePath.value : this.remotePath,
    quoteSnapshot: quoteSnapshot ?? this.quoteSnapshot,
    pricingSnapshot: pricingSnapshot ?? this.pricingSnapshot,
    totalsSnapshot: totalsSnapshot ?? this.totalsSnapshot,
  );

  FinalizedDocumentRow copyWithCompanion(FinalizedDocumentsCompanion data) {
    return FinalizedDocumentRow(
      id: data.id.present ? data.id.value : id,
      orgId: data.orgId.present ? data.orgId.value : orgId,
      quoteId: data.quoteId.present ? data.quoteId.value : quoteId,
      docType: data.docType.present ? data.docType.value : docType,
      createdAt: data.createdAt.present ? data.createdAt.value : createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : updatedAt,
      status: data.status.present ? data.status.value : status,
      localPath: data.localPath.present ? data.localPath.value : localPath,
      remotePath: data.remotePath.present ? data.remotePath.value : remotePath,
      quoteSnapshot: data.quoteSnapshot.present
          ? data.quoteSnapshot.value
          : quoteSnapshot,
      pricingSnapshot: data.pricingSnapshot.present
          ? data.pricingSnapshot.value
          : pricingSnapshot,
      totalsSnapshot: data.totalsSnapshot.present
          ? data.totalsSnapshot.value
          : totalsSnapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinalizedDocumentRow(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('quoteId: $quoteId, ')
          ..write('docType: $docType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('status: $status, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('quoteSnapshot: $quoteSnapshot, ')
          ..write('pricingSnapshot: $pricingSnapshot, ')
          ..write('totalsSnapshot: $totalsSnapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgId,
    quoteId,
    docType,
    createdAt,
    updatedAt,
    status,
    localPath,
    remotePath,
    quoteSnapshot,
    pricingSnapshot,
    totalsSnapshot,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinalizedDocumentRow &&
          other.id == id &&
          other.orgId == orgId &&
          other.quoteId == quoteId &&
          other.docType == docType &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt &&
          other.status == status &&
          other.localPath == localPath &&
          other.remotePath == remotePath &&
          other.quoteSnapshot == quoteSnapshot &&
          other.pricingSnapshot == pricingSnapshot &&
          other.totalsSnapshot == totalsSnapshot);
}

class FinalizedDocumentsCompanion
    extends UpdateCompanion<FinalizedDocumentRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> quoteId;
  final Value<String> docType;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> status;
  final Value<String> localPath;
  final Value<String?> remotePath;
  final Value<String> quoteSnapshot;
  final Value<String> pricingSnapshot;
  final Value<String> totalsSnapshot;
  final Value<int> rowid;
  const FinalizedDocumentsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.docType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.localPath = const Value.absent(),
    this.remotePath = const Value.absent(),
    this.quoteSnapshot = const Value.absent(),
    this.pricingSnapshot = const Value.absent(),
    this.totalsSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinalizedDocumentsCompanion.insert({
    required String id,
    required String orgId,
    required String quoteId,
    required String docType,
    required int createdAt,
    required int updatedAt,
    required String status,
    required String localPath,
    this.remotePath = const Value.absent(),
    required String quoteSnapshot,
    required String pricingSnapshot,
    required String totalsSnapshot,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       quoteId = Value(quoteId),
       docType = Value(docType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       status = Value(status),
       localPath = Value(localPath),
       quoteSnapshot = Value(quoteSnapshot),
       pricingSnapshot = Value(pricingSnapshot),
       totalsSnapshot = Value(totalsSnapshot);
  static Insertable<FinalizedDocumentRow> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? quoteId,
    Expression<String>? docType,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? status,
    Expression<String>? localPath,
    Expression<String>? remotePath,
    Expression<String>? quoteSnapshot,
    Expression<String>? pricingSnapshot,
    Expression<String>? totalsSnapshot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (quoteId != null) 'quote_id': quoteId,
      if (docType != null) 'doc_type': docType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (status != null) 'status': status,
      if (localPath != null) 'local_path': localPath,
      if (remotePath != null) 'remote_path': remotePath,
      if (quoteSnapshot != null) 'quote_snapshot': quoteSnapshot,
      if (pricingSnapshot != null) 'pricing_snapshot': pricingSnapshot,
      if (totalsSnapshot != null) 'totals_snapshot': totalsSnapshot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinalizedDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? quoteId,
    Value<String>? docType,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? status,
    Value<String>? localPath,
    Value<String?>? remotePath,
    Value<String>? quoteSnapshot,
    Value<String>? pricingSnapshot,
    Value<String>? totalsSnapshot,
    Value<int>? rowid,
  }) {
    return FinalizedDocumentsCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      quoteId: quoteId ?? this.quoteId,
      docType: docType ?? this.docType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      localPath: localPath ?? this.localPath,
      remotePath: remotePath ?? this.remotePath,
      quoteSnapshot: quoteSnapshot ?? this.quoteSnapshot,
      pricingSnapshot: pricingSnapshot ?? this.pricingSnapshot,
      totalsSnapshot: totalsSnapshot ?? this.totalsSnapshot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (docType.present) {
      map['doc_type'] = Variable<String>(docType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (remotePath.present) {
      final v = remotePath.value;
      if (v != null) {
        map['remote_path'] = Variable<String>(v);
      }
    }
    if (quoteSnapshot.present) {
      map['quote_snapshot'] = Variable<String>(quoteSnapshot.value);
    }
    if (pricingSnapshot.present) {
      map['pricing_snapshot'] = Variable<String>(pricingSnapshot.value);
    }
    if (totalsSnapshot.present) {
      map['totals_snapshot'] = Variable<String>(totalsSnapshot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinalizedDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('quoteId: $quoteId, ')
          ..write('docType: $docType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('status: $status, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('quoteSnapshot: $quoteSnapshot, ')
          ..write('pricingSnapshot: $pricingSnapshot, ')
          ..write('totalsSnapshot: $totalsSnapshot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $QuotesTable quotes = $QuotesTable(this);
  late final $QuoteItemsTable quoteItems = $QuoteItemsTable(this);
  late final $OrgSettingsTableTable orgSettingsTable = $OrgSettingsTableTable(
    this,
  );
  late final $PricingProfilesTable pricingProfiles = $PricingProfilesTable(
    this,
  );
  late final $PricingProfileServiceTypesTable pricingProfileServiceTypes =
      $PricingProfileServiceTypesTable(this);
  late final $PricingProfileFrequenciesTable pricingProfileFrequencies =
      $PricingProfileFrequenciesTable(this);
  late final $PricingProfileRoomTypesTable pricingProfileRoomTypes =
      $PricingProfileRoomTypesTable(this);
  late final $PricingProfileSubItemsTable pricingProfileSubItems =
      $PricingProfileSubItemsTable(this);
  late final $PricingProfileSizesTable pricingProfileSizes =
      $PricingProfileSizesTable(this);
  late final $PricingProfileComplexitiesTable pricingProfileComplexities =
      $PricingProfileComplexitiesTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $FinalizedDocumentsTable finalizedDocuments =
      $FinalizedDocumentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clients,
    quotes,
    quoteItems,
    orgSettingsTable,
    pricingProfiles,
    pricingProfileServiceTypes,
    pricingProfileFrequencies,
    pricingProfileRoomTypes,
    pricingProfileSubItems,
    pricingProfileSizes,
    pricingProfileComplexities,
    outbox,
    syncState,
    finalizedDocuments,
  ];
}

typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      required String id,
      required String orgId,
      required int updatedAt,
      Value<bool> deleted,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> street1,
      Value<String> street2,
      Value<String> city,
      Value<String> state,
      Value<String> zip,
      Value<String> phone,
      Value<String> email,
      Value<String> notes,
      Value<int> rowid,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<String> id,
      Value<String> orgId,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> street1,
      Value<String> street2,
      Value<String> city,
      Value<String> state,
      Value<String> zip,
      Value<String> phone,
      Value<String> email,
      Value<String> notes,
      Value<int> rowid,
    });

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get street1 => $composableBuilder(
    column: $table.street1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get street2 => $composableBuilder(
    column: $table.street2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zip => $composableBuilder(
    column: $table.zip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get street1 => $composableBuilder(
    column: $table.street1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get street2 => $composableBuilder(
    column: $table.street2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zip => $composableBuilder(
    column: $table.zip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get street1 =>
      $composableBuilder(column: $table.street1, builder: (column) => column);

  GeneratedColumn<String> get street2 =>
      $composableBuilder(column: $table.street2, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get zip =>
      $composableBuilder(column: $table.zip, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          ClientRow,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (ClientRow, BaseReferences<_$AppDatabase, $ClientsTable, ClientRow>),
          ClientRow,
          PrefetchHooks Function()
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> street1 = const Value.absent(),
                Value<String> street2 = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> zip = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                orgId: orgId,
                updatedAt: updatedAt,
                deleted: deleted,
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
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orgId,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> street1 = const Value.absent(),
                Value<String> street2 = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> zip = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                orgId: orgId,
                updatedAt: updatedAt,
                deleted: deleted,
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
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      ClientRow,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (ClientRow, BaseReferences<_$AppDatabase, $ClientsTable, ClientRow>),
      ClientRow,
      PrefetchHooks Function()
    >;
typedef $$QuotesTableCreateCompanionBuilder =
    QuotesCompanion Function({
      required String id,
      required String orgId,
      required int updatedAt,
      Value<bool> deleted,
      Value<String> clientId,
      Value<String> clientName,
      Value<String> quoteName,
      Value<String> quoteDate,
      Value<String> serviceType,
      Value<String> frequency,
      Value<String> lastProClean,
      Value<String> status,
      Value<double> total,
      Value<String> address,
      Value<String> totalSqFt,
      Value<bool> useTotalSqFt,
      Value<String> estimatedSqFt,
      Value<bool> petsPresent,
      Value<bool> homeOccupied,
      Value<String> entryCode,
      Value<String> paymentMethod,
      Value<bool> feedbackDiscussed,
      Value<double> laborRate,
      Value<bool> taxEnabled,
      Value<bool> ccEnabled,
      Value<double> taxRate,
      Value<double> ccRate,
      Value<String> defaultRoomType,
      Value<String> defaultLevel,
      Value<String> defaultSize,
      Value<String> defaultComplexity,
      Value<String> subItemType,
      Value<String> specialNotes,
      Value<int> rowid,
    });
typedef $$QuotesTableUpdateCompanionBuilder =
    QuotesCompanion Function({
      Value<String> id,
      Value<String> orgId,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<String> clientId,
      Value<String> clientName,
      Value<String> quoteName,
      Value<String> quoteDate,
      Value<String> serviceType,
      Value<String> frequency,
      Value<String> lastProClean,
      Value<String> status,
      Value<double> total,
      Value<String> address,
      Value<String> totalSqFt,
      Value<bool> useTotalSqFt,
      Value<String> estimatedSqFt,
      Value<bool> petsPresent,
      Value<bool> homeOccupied,
      Value<String> entryCode,
      Value<String> paymentMethod,
      Value<bool> feedbackDiscussed,
      Value<double> laborRate,
      Value<bool> taxEnabled,
      Value<bool> ccEnabled,
      Value<double> taxRate,
      Value<double> ccRate,
      Value<String> defaultRoomType,
      Value<String> defaultLevel,
      Value<String> defaultSize,
      Value<String> defaultComplexity,
      Value<String> subItemType,
      Value<String> specialNotes,
      Value<int> rowid,
    });

class $$QuotesTableFilterComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteName => $composableBuilder(
    column: $table.quoteName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteDate => $composableBuilder(
    column: $table.quoteDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastProClean => $composableBuilder(
    column: $table.lastProClean,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get totalSqFt => $composableBuilder(
    column: $table.totalSqFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useTotalSqFt => $composableBuilder(
    column: $table.useTotalSqFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estimatedSqFt => $composableBuilder(
    column: $table.estimatedSqFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get petsPresent => $composableBuilder(
    column: $table.petsPresent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeOccupied => $composableBuilder(
    column: $table.homeOccupied,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryCode => $composableBuilder(
    column: $table.entryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get feedbackDiscussed => $composableBuilder(
    column: $table.feedbackDiscussed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get laborRate => $composableBuilder(
    column: $table.laborRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get taxEnabled => $composableBuilder(
    column: $table.taxEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ccEnabled => $composableBuilder(
    column: $table.ccEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ccRate => $composableBuilder(
    column: $table.ccRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultRoomType => $composableBuilder(
    column: $table.defaultRoomType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultLevel => $composableBuilder(
    column: $table.defaultLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultSize => $composableBuilder(
    column: $table.defaultSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultComplexity => $composableBuilder(
    column: $table.defaultComplexity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subItemType => $composableBuilder(
    column: $table.subItemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialNotes => $composableBuilder(
    column: $table.specialNotes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuotesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteName => $composableBuilder(
    column: $table.quoteName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteDate => $composableBuilder(
    column: $table.quoteDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastProClean => $composableBuilder(
    column: $table.lastProClean,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get totalSqFt => $composableBuilder(
    column: $table.totalSqFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useTotalSqFt => $composableBuilder(
    column: $table.useTotalSqFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estimatedSqFt => $composableBuilder(
    column: $table.estimatedSqFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get petsPresent => $composableBuilder(
    column: $table.petsPresent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeOccupied => $composableBuilder(
    column: $table.homeOccupied,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryCode => $composableBuilder(
    column: $table.entryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get feedbackDiscussed => $composableBuilder(
    column: $table.feedbackDiscussed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get laborRate => $composableBuilder(
    column: $table.laborRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get taxEnabled => $composableBuilder(
    column: $table.taxEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ccEnabled => $composableBuilder(
    column: $table.ccEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ccRate => $composableBuilder(
    column: $table.ccRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultRoomType => $composableBuilder(
    column: $table.defaultRoomType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultLevel => $composableBuilder(
    column: $table.defaultLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultSize => $composableBuilder(
    column: $table.defaultSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultComplexity => $composableBuilder(
    column: $table.defaultComplexity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subItemType => $composableBuilder(
    column: $table.subItemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialNotes => $composableBuilder(
    column: $table.specialNotes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quoteName =>
      $composableBuilder(column: $table.quoteName, builder: (column) => column);

  GeneratedColumn<String> get quoteDate =>
      $composableBuilder(column: $table.quoteDate, builder: (column) => column);

  GeneratedColumn<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get lastProClean => $composableBuilder(
    column: $table.lastProClean,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get totalSqFt =>
      $composableBuilder(column: $table.totalSqFt, builder: (column) => column);

  GeneratedColumn<bool> get useTotalSqFt => $composableBuilder(
    column: $table.useTotalSqFt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estimatedSqFt => $composableBuilder(
    column: $table.estimatedSqFt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get petsPresent => $composableBuilder(
    column: $table.petsPresent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeOccupied => $composableBuilder(
    column: $table.homeOccupied,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entryCode =>
      $composableBuilder(column: $table.entryCode, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get feedbackDiscussed => $composableBuilder(
    column: $table.feedbackDiscussed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get laborRate =>
      $composableBuilder(column: $table.laborRate, builder: (column) => column);

  GeneratedColumn<bool> get taxEnabled => $composableBuilder(
    column: $table.taxEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ccEnabled =>
      $composableBuilder(column: $table.ccEnabled, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<double> get ccRate =>
      $composableBuilder(column: $table.ccRate, builder: (column) => column);

  GeneratedColumn<String> get defaultRoomType => $composableBuilder(
    column: $table.defaultRoomType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultLevel => $composableBuilder(
    column: $table.defaultLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultSize => $composableBuilder(
    column: $table.defaultSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultComplexity => $composableBuilder(
    column: $table.defaultComplexity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subItemType => $composableBuilder(
    column: $table.subItemType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get specialNotes => $composableBuilder(
    column: $table.specialNotes,
    builder: (column) => column,
  );
}

class $$QuotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuotesTable,
          QuoteRow,
          $$QuotesTableFilterComposer,
          $$QuotesTableOrderingComposer,
          $$QuotesTableAnnotationComposer,
          $$QuotesTableCreateCompanionBuilder,
          $$QuotesTableUpdateCompanionBuilder,
          (QuoteRow, BaseReferences<_$AppDatabase, $QuotesTable, QuoteRow>),
          QuoteRow,
          PrefetchHooks Function()
        > {
  $$QuotesTableTableManager(_$AppDatabase db, $QuotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> clientName = const Value.absent(),
                Value<String> quoteName = const Value.absent(),
                Value<String> quoteDate = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String> lastProClean = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> totalSqFt = const Value.absent(),
                Value<bool> useTotalSqFt = const Value.absent(),
                Value<String> estimatedSqFt = const Value.absent(),
                Value<bool> petsPresent = const Value.absent(),
                Value<bool> homeOccupied = const Value.absent(),
                Value<String> entryCode = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<bool> feedbackDiscussed = const Value.absent(),
                Value<double> laborRate = const Value.absent(),
                Value<bool> taxEnabled = const Value.absent(),
                Value<bool> ccEnabled = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> ccRate = const Value.absent(),
                Value<String> defaultRoomType = const Value.absent(),
                Value<String> defaultLevel = const Value.absent(),
                Value<String> defaultSize = const Value.absent(),
                Value<String> defaultComplexity = const Value.absent(),
                Value<String> subItemType = const Value.absent(),
                Value<String> specialNotes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuotesCompanion(
                id: id,
                orgId: orgId,
                updatedAt: updatedAt,
                deleted: deleted,
                clientId: clientId,
                clientName: clientName,
                quoteName: quoteName,
                quoteDate: quoteDate,
                serviceType: serviceType,
                frequency: frequency,
                lastProClean: lastProClean,
                status: status,
                total: total,
                address: address,
                totalSqFt: totalSqFt,
                useTotalSqFt: useTotalSqFt,
                estimatedSqFt: estimatedSqFt,
                petsPresent: petsPresent,
                homeOccupied: homeOccupied,
                entryCode: entryCode,
                paymentMethod: paymentMethod,
                feedbackDiscussed: feedbackDiscussed,
                laborRate: laborRate,
                taxEnabled: taxEnabled,
                ccEnabled: ccEnabled,
                taxRate: taxRate,
                ccRate: ccRate,
                defaultRoomType: defaultRoomType,
                defaultLevel: defaultLevel,
                defaultSize: defaultSize,
                defaultComplexity: defaultComplexity,
                subItemType: subItemType,
                specialNotes: specialNotes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orgId,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> clientName = const Value.absent(),
                Value<String> quoteName = const Value.absent(),
                Value<String> quoteDate = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String> lastProClean = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> totalSqFt = const Value.absent(),
                Value<bool> useTotalSqFt = const Value.absent(),
                Value<String> estimatedSqFt = const Value.absent(),
                Value<bool> petsPresent = const Value.absent(),
                Value<bool> homeOccupied = const Value.absent(),
                Value<String> entryCode = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<bool> feedbackDiscussed = const Value.absent(),
                Value<double> laborRate = const Value.absent(),
                Value<bool> taxEnabled = const Value.absent(),
                Value<bool> ccEnabled = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> ccRate = const Value.absent(),
                Value<String> defaultRoomType = const Value.absent(),
                Value<String> defaultLevel = const Value.absent(),
                Value<String> defaultSize = const Value.absent(),
                Value<String> defaultComplexity = const Value.absent(),
                Value<String> subItemType = const Value.absent(),
                Value<String> specialNotes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuotesCompanion.insert(
                id: id,
                orgId: orgId,
                updatedAt: updatedAt,
                deleted: deleted,
                clientId: clientId,
                clientName: clientName,
                quoteName: quoteName,
                quoteDate: quoteDate,
                serviceType: serviceType,
                frequency: frequency,
                lastProClean: lastProClean,
                status: status,
                total: total,
                address: address,
                totalSqFt: totalSqFt,
                useTotalSqFt: useTotalSqFt,
                estimatedSqFt: estimatedSqFt,
                petsPresent: petsPresent,
                homeOccupied: homeOccupied,
                entryCode: entryCode,
                paymentMethod: paymentMethod,
                feedbackDiscussed: feedbackDiscussed,
                laborRate: laborRate,
                taxEnabled: taxEnabled,
                ccEnabled: ccEnabled,
                taxRate: taxRate,
                ccRate: ccRate,
                defaultRoomType: defaultRoomType,
                defaultLevel: defaultLevel,
                defaultSize: defaultSize,
                defaultComplexity: defaultComplexity,
                subItemType: subItemType,
                specialNotes: specialNotes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuotesTable,
      QuoteRow,
      $$QuotesTableFilterComposer,
      $$QuotesTableOrderingComposer,
      $$QuotesTableAnnotationComposer,
      $$QuotesTableCreateCompanionBuilder,
      $$QuotesTableUpdateCompanionBuilder,
      (QuoteRow, BaseReferences<_$AppDatabase, $QuotesTable, QuoteRow>),
      QuoteRow,
      PrefetchHooks Function()
    >;
typedef $$QuoteItemsTableCreateCompanionBuilder =
    QuoteItemsCompanion Function({
      required String id,
      required String orgId,
      required String quoteId,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> sortOrder,
      Value<String> payload,
      Value<int> rowid,
    });
typedef $$QuoteItemsTableUpdateCompanionBuilder =
    QuoteItemsCompanion Function({
      Value<String> id,
      Value<String> orgId,
      Value<String> quoteId,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> sortOrder,
      Value<String> payload,
      Value<int> rowid,
    });

class $$QuoteItemsTableFilterComposer
    extends Composer<_$AppDatabase, $QuoteItemsTable> {
  $$QuoteItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuoteItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteItemsTable> {
  $$QuoteItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuoteItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteItemsTable> {
  $$QuoteItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get quoteId =>
      $composableBuilder(column: $table.quoteId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$QuoteItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteItemsTable,
          QuoteItemRow,
          $$QuoteItemsTableFilterComposer,
          $$QuoteItemsTableOrderingComposer,
          $$QuoteItemsTableAnnotationComposer,
          $$QuoteItemsTableCreateCompanionBuilder,
          $$QuoteItemsTableUpdateCompanionBuilder,
          (
            QuoteItemRow,
            BaseReferences<_$AppDatabase, $QuoteItemsTable, QuoteItemRow>,
          ),
          QuoteItemRow,
          PrefetchHooks Function()
        > {
  $$QuoteItemsTableTableManager(_$AppDatabase db, $QuoteItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuoteItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuoteItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> quoteId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuoteItemsCompanion(
                id: id,
                orgId: orgId,
                quoteId: quoteId,
                updatedAt: updatedAt,
                deleted: deleted,
                sortOrder: sortOrder,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orgId,
                required String quoteId,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuoteItemsCompanion.insert(
                id: id,
                orgId: orgId,
                quoteId: quoteId,
                updatedAt: updatedAt,
                deleted: deleted,
                sortOrder: sortOrder,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuoteItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteItemsTable,
      QuoteItemRow,
      $$QuoteItemsTableFilterComposer,
      $$QuoteItemsTableOrderingComposer,
      $$QuoteItemsTableAnnotationComposer,
      $$QuoteItemsTableCreateCompanionBuilder,
      $$QuoteItemsTableUpdateCompanionBuilder,
      (
        QuoteItemRow,
        BaseReferences<_$AppDatabase, $QuoteItemsTable, QuoteItemRow>,
      ),
      QuoteItemRow,
      PrefetchHooks Function()
    >;
typedef $$OrgSettingsTableTableCreateCompanionBuilder =
    OrgSettingsTableCompanion Function({
      required String orgId,
      required int updatedAt,
      Value<bool> deleted,
      Value<double> laborRate,
      Value<bool> taxEnabled,
      Value<double> taxRate,
      Value<bool> ccEnabled,
      Value<double> ccRate,
      Value<int> rowid,
    });
typedef $$OrgSettingsTableTableUpdateCompanionBuilder =
    OrgSettingsTableCompanion Function({
      Value<String> orgId,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<double> laborRate,
      Value<bool> taxEnabled,
      Value<double> taxRate,
      Value<bool> ccEnabled,
      Value<double> ccRate,
      Value<int> rowid,
    });

class $$OrgSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrgSettingsTableTable> {
  $$OrgSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get laborRate => $composableBuilder(
    column: $table.laborRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get taxEnabled => $composableBuilder(
    column: $table.taxEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ccEnabled => $composableBuilder(
    column: $table.ccEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ccRate => $composableBuilder(
    column: $table.ccRate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrgSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrgSettingsTableTable> {
  $$OrgSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get laborRate => $composableBuilder(
    column: $table.laborRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get taxEnabled => $composableBuilder(
    column: $table.taxEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ccEnabled => $composableBuilder(
    column: $table.ccEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ccRate => $composableBuilder(
    column: $table.ccRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrgSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrgSettingsTableTable> {
  $$OrgSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<double> get laborRate =>
      $composableBuilder(column: $table.laborRate, builder: (column) => column);

  GeneratedColumn<bool> get taxEnabled => $composableBuilder(
    column: $table.taxEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<bool> get ccEnabled =>
      $composableBuilder(column: $table.ccEnabled, builder: (column) => column);

  GeneratedColumn<double> get ccRate =>
      $composableBuilder(column: $table.ccRate, builder: (column) => column);
}

class $$OrgSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrgSettingsTableTable,
          OrgSettingsRow,
          $$OrgSettingsTableTableFilterComposer,
          $$OrgSettingsTableTableOrderingComposer,
          $$OrgSettingsTableTableAnnotationComposer,
          $$OrgSettingsTableTableCreateCompanionBuilder,
          $$OrgSettingsTableTableUpdateCompanionBuilder,
          (
            OrgSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $OrgSettingsTableTable,
              OrgSettingsRow
            >,
          ),
          OrgSettingsRow,
          PrefetchHooks Function()
        > {
  $$OrgSettingsTableTableTableManager(
    _$AppDatabase db,
    $OrgSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrgSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrgSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrgSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> orgId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<double> laborRate = const Value.absent(),
                Value<bool> taxEnabled = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<bool> ccEnabled = const Value.absent(),
                Value<double> ccRate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrgSettingsTableCompanion(
                orgId: orgId,
                updatedAt: updatedAt,
                deleted: deleted,
                laborRate: laborRate,
                taxEnabled: taxEnabled,
                taxRate: taxRate,
                ccEnabled: ccEnabled,
                ccRate: ccRate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String orgId,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<double> laborRate = const Value.absent(),
                Value<bool> taxEnabled = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<bool> ccEnabled = const Value.absent(),
                Value<double> ccRate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrgSettingsTableCompanion.insert(
                orgId: orgId,
                updatedAt: updatedAt,
                deleted: deleted,
                laborRate: laborRate,
                taxEnabled: taxEnabled,
                taxRate: taxRate,
                ccEnabled: ccEnabled,
                ccRate: ccRate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrgSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrgSettingsTableTable,
      OrgSettingsRow,
      $$OrgSettingsTableTableFilterComposer,
      $$OrgSettingsTableTableOrderingComposer,
      $$OrgSettingsTableTableAnnotationComposer,
      $$OrgSettingsTableTableCreateCompanionBuilder,
      $$OrgSettingsTableTableUpdateCompanionBuilder,
      (
        OrgSettingsRow,
        BaseReferences<_$AppDatabase, $OrgSettingsTableTable, OrgSettingsRow>,
      ),
      OrgSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder =
    OutboxCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String opType,
      required String payload,
      required int updatedAt,
      required String orgId,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$OutboxTableUpdateCompanionBuilder =
    OutboxCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> opType,
      Value<String> payload,
      Value<int> updatedAt,
      Value<String> orgId,
      Value<String> status,
      Value<int> rowid,
    });

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opType => $composableBuilder(
    column: $table.opType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opType => $composableBuilder(
    column: $table.opType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get opType =>
      $composableBuilder(column: $table.opType, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxRow,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> opType = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                opType: opType,
                payload: payload,
                updatedAt: updatedAt,
                orgId: orgId,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String opType,
                required String payload,
                required int updatedAt,
                required String orgId,
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                opType: opType,
                payload: payload,
                updatedAt: updatedAt,
                orgId: orgId,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxRow,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
      OutboxRow,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String id,
      required String orgId,
      Value<int> lastSyncAt,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> id,
      Value<String> orgId,
      Value<int> lastSyncAt,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateRow,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateRow,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
          ),
          SyncStateRow,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<int> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(
                id: id,
                orgId: orgId,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orgId,
                Value<int> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                id: id,
                orgId: orgId,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateRow,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateRow,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
      ),
      SyncStateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$QuotesTableTableManager get quotes =>
      $$QuotesTableTableManager(_db, _db.quotes);
  $$QuoteItemsTableTableManager get quoteItems =>
      $$QuoteItemsTableTableManager(_db, _db.quoteItems);
  $$OrgSettingsTableTableTableManager get orgSettingsTable =>
      $$OrgSettingsTableTableTableManager(_db, _db.orgSettingsTable);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
}

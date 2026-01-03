// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_db.dart';

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
  factory ClientRow.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ClientRow(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      orgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}org_id'])!,
      updatedAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
      firstName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}first_name'])!,
      lastName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_name'])!,
      street1: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}street1'])!,
      street2: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}street2'])!,
      city: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}city'])!,
      state: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}state'])!,
      zip: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}zip'])!,
      phone: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}phone'])!,
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email'])!,
      notes: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}notes'])!,
    );
  }
  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return {
      'id': Variable<String>(id),
      'org_id': Variable<String>(orgId),
      'updated_at': Variable<int>(updatedAt),
      'deleted': Variable<bool>(deleted),
      'first_name': Variable<String>(firstName),
      'last_name': Variable<String>(lastName),
      'street1': Variable<String>(street1),
      'street2': Variable<String>(street2),
      'city': Variable<String>(city),
      'state': Variable<String>(state),
      'zip': Variable<String>(zip),
      'phone': Variable<String>(phone),
      'email': Variable<String>(email),
      'notes': Variable<String>(notes),
    };
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
  });
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
    });
  }
}

class $ClientsTable extends Clients
    with TableInfo<$ClientsTable, ClientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  static const VerificationMeta _orgIdMeta = VerificationMeta('orgId');
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  static const VerificationMeta _deletedMeta = VerificationMeta('deleted');
  static const VerificationMeta _firstNameMeta = VerificationMeta('firstName');
  static const VerificationMeta _lastNameMeta = VerificationMeta('lastName');
  static const VerificationMeta _street1Meta = VerificationMeta('street1');
  static const VerificationMeta _street2Meta = VerificationMeta('street2');
  static const VerificationMeta _cityMeta = VerificationMeta('city');
  static const VerificationMeta _stateMeta = VerificationMeta('state');
  static const VerificationMeta _zipMeta = VerificationMeta('zip');
  static const VerificationMeta _phoneMeta = VerificationMeta('phone');
  static const VerificationMeta _emailMeta = VerificationMeta('email');
  static const VerificationMeta _notesMeta = VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
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
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  @override
  late final GeneratedColumn<String> street2 = GeneratedColumn<String>(
    'street2',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumn<String> zip = GeneratedColumn<String>(
    'zip',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
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
  String get aliasedName => _alias ?? 'clients';
  @override
  String get actualTableName => 'clients';
  @override
  VerificationContext validateIntegrity(Insertable<ClientRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('org_id')) {
      context.handle(
          _orgIdMeta, orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    }
    if (data.containsKey('street1')) {
      context.handle(_street1Meta,
          street1.isAcceptableOrUnknown(data['street1']!, _street1Meta));
    }
    if (data.containsKey('street2')) {
      context.handle(_street2Meta,
          street2.isAcceptableOrUnknown(data['street2']!, _street2Meta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    }
    if (data.containsKey('zip')) {
      context.handle(
          _zipMeta, zip.isAcceptableOrUnknown(data['zip']!, _zipMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  ClientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ClientRow.fromData(data, prefix: tablePrefix);
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
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
    required this.defaultRoomType,
    required this.defaultLevel,
    required this.defaultSize,
    required this.defaultComplexity,
    required this.subItemType,
    required this.specialNotes,
  });
  factory QuoteRow.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return QuoteRow(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      orgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}org_id'])!,
      updatedAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
      clientId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}client_id'])!,
      clientName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}client_name'])!,
      quoteName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quote_name'])!,
      quoteDate: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quote_date'])!,
      serviceType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}service_type'])!,
      frequency: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}frequency'])!,
      lastProClean: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_pro_clean'])!,
      status: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      total: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total'])!,
      address: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}address'])!,
      totalSqFt: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total_sq_ft'])!,
      useTotalSqFt: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}use_total_sq_ft'])!,
      estimatedSqFt: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}estimated_sq_ft'])!,
      petsPresent: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pets_present'])!,
      homeOccupied: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}home_occupied'])!,
      entryCode: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}entry_code'])!,
      paymentMethod: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payment_method'])!,
      feedbackDiscussed: const BoolType().mapFromDatabaseResponse(
          data['${effectivePrefix}feedback_discussed'])!,
      laborRate: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}labor_rate'])!,
      taxEnabled: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tax_enabled'])!,
      ccEnabled: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cc_enabled'])!,
      taxRate: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tax_rate'])!,
      ccRate: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cc_rate'])!,
      defaultRoomType: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}default_room_type'])!,
      defaultLevel: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}default_level'])!,
      defaultSize: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}default_size'])!,
      defaultComplexity: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}default_complexity'])!,
      subItemType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sub_item_type'])!,
      specialNotes: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}special_notes'])!,
    );
  }
  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return {
      'id': Variable<String>(id),
      'org_id': Variable<String>(orgId),
      'updated_at': Variable<int>(updatedAt),
      'deleted': Variable<bool>(deleted),
      'client_id': Variable<String>(clientId),
      'client_name': Variable<String>(clientName),
      'quote_name': Variable<String>(quoteName),
      'quote_date': Variable<String>(quoteDate),
      'service_type': Variable<String>(serviceType),
      'frequency': Variable<String>(frequency),
      'last_pro_clean': Variable<String>(lastProClean),
      'status': Variable<String>(status),
      'total': Variable<double>(total),
      'address': Variable<String>(address),
      'total_sq_ft': Variable<String>(totalSqFt),
      'use_total_sq_ft': Variable<bool>(useTotalSqFt),
      'estimated_sq_ft': Variable<String>(estimatedSqFt),
      'pets_present': Variable<bool>(petsPresent),
      'home_occupied': Variable<bool>(homeOccupied),
      'entry_code': Variable<String>(entryCode),
      'payment_method': Variable<String>(paymentMethod),
      'feedback_discussed': Variable<bool>(feedbackDiscussed),
      'labor_rate': Variable<double>(laborRate),
      'tax_enabled': Variable<bool>(taxEnabled),
      'cc_enabled': Variable<bool>(ccEnabled),
      'tax_rate': Variable<double>(taxRate),
      'cc_rate': Variable<double>(ccRate),
      'default_room_type': Variable<String>(defaultRoomType),
      'default_level': Variable<String>(defaultLevel),
      'default_size': Variable<String>(defaultSize),
      'default_complexity': Variable<String>(defaultComplexity),
      'sub_item_type': Variable<String>(subItemType),
      'special_notes': Variable<String>(specialNotes),
    };
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
      defaultRoomType: Value(defaultRoomType),
      defaultLevel: Value(defaultLevel),
      defaultSize: Value(defaultSize),
      defaultComplexity: Value(defaultComplexity),
      subItemType: Value(subItemType),
      specialNotes: Value(specialNotes),
    );
  }
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
  final Value<String> defaultRoomType;
  final Value<String> defaultLevel;
  final Value<String> defaultSize;
  final Value<String> defaultComplexity;
  final Value<String> subItemType;
  final Value<String> specialNotes;
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
    this.defaultRoomType = const Value.absent(),
    this.defaultLevel = const Value.absent(),
    this.defaultSize = const Value.absent(),
    this.defaultComplexity = const Value.absent(),
    this.subItemType = const Value.absent(),
    this.specialNotes = const Value.absent(),
  });
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
    Expression<String>? defaultRoomType,
    Expression<String>? defaultLevel,
    Expression<String>? defaultSize,
    Expression<String>? defaultComplexity,
    Expression<String>? subItemType,
    Expression<String>? specialNotes,
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
      if (defaultRoomType != null) 'default_room_type': defaultRoomType,
      if (defaultLevel != null) 'default_level': defaultLevel,
      if (defaultSize != null) 'default_size': defaultSize,
      if (defaultComplexity != null) 'default_complexity': defaultComplexity,
      if (subItemType != null) 'sub_item_type': subItemType,
      if (specialNotes != null) 'special_notes': specialNotes,
    });
  }
}

class $QuotesTable extends Quotes with TableInfo<$QuotesTable, QuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  static const VerificationMeta _orgIdMeta = VerificationMeta('orgId');
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  static const VerificationMeta _deletedMeta = VerificationMeta('deleted');
  static const VerificationMeta _clientIdMeta = VerificationMeta('clientId');
  static const VerificationMeta _clientNameMeta =
      VerificationMeta('clientName');
  static const VerificationMeta _quoteNameMeta = VerificationMeta('quoteName');
  static const VerificationMeta _quoteDateMeta = VerificationMeta('quoteDate');
  static const VerificationMeta _serviceTypeMeta =
      VerificationMeta('serviceType');
  static const VerificationMeta _frequencyMeta = VerificationMeta('frequency');
  static const VerificationMeta _lastProCleanMeta =
      VerificationMeta('lastProClean');
  static const VerificationMeta _statusMeta = VerificationMeta('status');
  static const VerificationMeta _totalMeta = VerificationMeta('total');
  static const VerificationMeta _addressMeta = VerificationMeta('address');
  static const VerificationMeta _totalSqFtMeta = VerificationMeta('totalSqFt');
  static const VerificationMeta _useTotalSqFtMeta =
      VerificationMeta('useTotalSqFt');
  static const VerificationMeta _estimatedSqFtMeta =
      VerificationMeta('estimatedSqFt');
  static const VerificationMeta _petsPresentMeta =
      VerificationMeta('petsPresent');
  static const VerificationMeta _homeOccupiedMeta =
      VerificationMeta('homeOccupied');
  static const VerificationMeta _entryCodeMeta = VerificationMeta('entryCode');
  static const VerificationMeta _paymentMethodMeta =
      VerificationMeta('paymentMethod');
  static const VerificationMeta _feedbackDiscussedMeta =
      VerificationMeta('feedbackDiscussed');
  static const VerificationMeta _laborRateMeta = VerificationMeta('laborRate');
  static const VerificationMeta _taxEnabledMeta =
      VerificationMeta('taxEnabled');
  static const VerificationMeta _ccEnabledMeta = VerificationMeta('ccEnabled');
  static const VerificationMeta _taxRateMeta = VerificationMeta('taxRate');
  static const VerificationMeta _ccRateMeta = VerificationMeta('ccRate');
  static const VerificationMeta _defaultRoomTypeMeta =
      VerificationMeta('defaultRoomType');
  static const VerificationMeta _defaultLevelMeta =
      VerificationMeta('defaultLevel');
  static const VerificationMeta _defaultSizeMeta =
      VerificationMeta('defaultSize');
  static const VerificationMeta _defaultComplexityMeta =
      VerificationMeta('defaultComplexity');
  static const VerificationMeta _subItemTypeMeta =
      VerificationMeta('subItemType');
  static const VerificationMeta _specialNotesMeta =
      VerificationMeta('specialNotes');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
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
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  @override
  late final GeneratedColumn<String> quoteDate = GeneratedColumn<String>(
    'quote_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Draft'),
  );
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  late final GeneratedColumn<String> totalSqFt = GeneratedColumn<String>(
    'total_sq_ft',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumn<bool> useTotalSqFt = GeneratedColumn<bool>(
    'use_total_sq_ft',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(true),
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
  @override
  late final GeneratedColumn<bool> petsPresent = GeneratedColumn<bool>(
    'pets_present',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumn<bool> homeOccupied = GeneratedColumn<bool>(
    'home_occupied',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(true),
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
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumn<bool> feedbackDiscussed = GeneratedColumn<bool>(
    'feedback_discussed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
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
  @override
  late final GeneratedColumn<bool> taxEnabled = GeneratedColumn<bool>(
    'tax_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumn<bool> ccEnabled = GeneratedColumn<bool>(
    'cc_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
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
  @override
  late final GeneratedColumn<double> ccRate = GeneratedColumn<double>(
    'cc_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.03),
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
  @override
  late final GeneratedColumn<String> defaultLevel = GeneratedColumn<String>(
    'default_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  @override
  late final GeneratedColumn<String> subItemType = GeneratedColumn<String>(
    'sub_item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
        defaultRoomType,
        defaultLevel,
        defaultSize,
        defaultComplexity,
        subItemType,
        specialNotes,
      ];
  @override
  String get aliasedName => _alias ?? 'quotes';
  @override
  String get actualTableName => 'quotes';
  @override
  VerificationContext validateIntegrity(Insertable<QuoteRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('org_id')) {
      context.handle(
          _orgIdMeta, orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    }
    if (data.containsKey('client_name')) {
      context.handle(
          _clientNameMeta,
          clientName.isAcceptableOrUnknown(
              data['client_name']!, _clientNameMeta));
    }
    if (data.containsKey('quote_name')) {
      context.handle(_quoteNameMeta,
          quoteName.isAcceptableOrUnknown(data['quote_name']!, _quoteNameMeta));
    }
    if (data.containsKey('quote_date')) {
      context.handle(_quoteDateMeta,
          quoteDate.isAcceptableOrUnknown(data['quote_date']!, _quoteDateMeta));
    }
    if (data.containsKey('service_type')) {
      context.handle(
          _serviceTypeMeta,
          serviceType.isAcceptableOrUnknown(
              data['service_type']!, _serviceTypeMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('last_pro_clean')) {
      context.handle(
          _lastProCleanMeta,
          lastProClean.isAcceptableOrUnknown(
              data['last_pro_clean']!, _lastProCleanMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('total_sq_ft')) {
      context.handle(
          _totalSqFtMeta,
          totalSqFt.isAcceptableOrUnknown(
              data['total_sq_ft']!, _totalSqFtMeta));
    }
    if (data.containsKey('use_total_sq_ft')) {
      context.handle(
          _useTotalSqFtMeta,
          useTotalSqFt.isAcceptableOrUnknown(
              data['use_total_sq_ft']!, _useTotalSqFtMeta));
    }
    if (data.containsKey('estimated_sq_ft')) {
      context.handle(
          _estimatedSqFtMeta,
          estimatedSqFt.isAcceptableOrUnknown(
              data['estimated_sq_ft']!, _estimatedSqFtMeta));
    }
    if (data.containsKey('pets_present')) {
      context.handle(
          _petsPresentMeta,
          petsPresent.isAcceptableOrUnknown(
              data['pets_present']!, _petsPresentMeta));
    }
    if (data.containsKey('home_occupied')) {
      context.handle(
          _homeOccupiedMeta,
          homeOccupied.isAcceptableOrUnknown(
              data['home_occupied']!, _homeOccupiedMeta));
    }
    if (data.containsKey('entry_code')) {
      context.handle(_entryCodeMeta,
          entryCode.isAcceptableOrUnknown(data['entry_code']!, _entryCodeMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('feedback_discussed')) {
      context.handle(
          _feedbackDiscussedMeta,
          feedbackDiscussed.isAcceptableOrUnknown(
              data['feedback_discussed']!, _feedbackDiscussedMeta));
    }
    if (data.containsKey('labor_rate')) {
      context.handle(_laborRateMeta,
          laborRate.isAcceptableOrUnknown(data['labor_rate']!, _laborRateMeta));
    }
    if (data.containsKey('tax_enabled')) {
      context.handle(_taxEnabledMeta,
          taxEnabled.isAcceptableOrUnknown(data['tax_enabled']!, _taxEnabledMeta));
    }
    if (data.containsKey('cc_enabled')) {
      context.handle(_ccEnabledMeta,
          ccEnabled.isAcceptableOrUnknown(data['cc_enabled']!, _ccEnabledMeta));
    }
    if (data.containsKey('tax_rate')) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta));
    }
    if (data.containsKey('cc_rate')) {
      context.handle(_ccRateMeta,
          ccRate.isAcceptableOrUnknown(data['cc_rate']!, _ccRateMeta));
    }
    if (data.containsKey('default_room_type')) {
      context.handle(
          _defaultRoomTypeMeta,
          defaultRoomType.isAcceptableOrUnknown(
              data['default_room_type']!, _defaultRoomTypeMeta));
    }
    if (data.containsKey('default_level')) {
      context.handle(
          _defaultLevelMeta,
          defaultLevel.isAcceptableOrUnknown(
              data['default_level']!, _defaultLevelMeta));
    }
    if (data.containsKey('default_size')) {
      context.handle(_defaultSizeMeta,
          defaultSize.isAcceptableOrUnknown(data['default_size']!, _defaultSizeMeta));
    }
    if (data.containsKey('default_complexity')) {
      context.handle(
          _defaultComplexityMeta,
          defaultComplexity.isAcceptableOrUnknown(
              data['default_complexity']!, _defaultComplexityMeta));
    }
    if (data.containsKey('sub_item_type')) {
      context.handle(_subItemTypeMeta,
          subItemType.isAcceptableOrUnknown(data['sub_item_type']!, _subItemTypeMeta));
    }
    if (data.containsKey('special_notes')) {
      context.handle(_specialNotesMeta,
          specialNotes.isAcceptableOrUnknown(data['special_notes']!, _specialNotesMeta));
    }
    return context;
  }

  @override
  QuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    return QuoteRow.fromData(data, prefix: tablePrefix);
  }

  @override
  $QuotesTable createAlias(String alias) {
    return $QuotesTable(attachedDatabase, alias);
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
  factory QuoteItemRow.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return QuoteItemRow(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      orgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}org_id'])!,
      quoteId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quote_id'])!,
      updatedAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
      sortOrder: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sort_order'])!,
      payload: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payload'])!,
    );
  }
  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return {
      'id': Variable<String>(id),
      'org_id': Variable<String>(orgId),
      'quote_id': Variable<String>(quoteId),
      'updated_at': Variable<int>(updatedAt),
      'deleted': Variable<bool>(deleted),
      'sort_order': Variable<int>(sortOrder),
      'payload': Variable<String>(payload),
    };
  }
}

class QuoteItemsCompanion extends UpdateCompanion<QuoteItemRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> quoteId;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> sortOrder;
  final Value<String> payload;
  const QuoteItemsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.payload = const Value.absent(),
  });
}

class $QuoteItemsTable extends QuoteItems
    with TableInfo<$QuoteItemsTable, QuoteItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteItemsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
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
  List<GeneratedColumn> get $columns =>
      [id, orgId, quoteId, updatedAt, deleted, sortOrder, payload];
  @override
  String get aliasedName => _alias ?? 'quote_items';
  @override
  String get actualTableName => 'quote_items';
  @override
  VerificationContext validateIntegrity(Insertable<QuoteItemRow> instance,
      {bool isInserting = false}) {
    return VerificationContext();
  }
  @override
  QuoteItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    return QuoteItemRow.fromData(data, prefix: tablePrefix);
  }

  @override
  $QuoteItemsTable createAlias(String alias) {
    return $QuoteItemsTable(attachedDatabase, alias);
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
  const OrgSettingsRow({
    required this.orgId,
    required this.updatedAt,
    required this.deleted,
    required this.laborRate,
    required this.taxEnabled,
    required this.taxRate,
    required this.ccEnabled,
    required this.ccRate,
  });
  factory OrgSettingsRow.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return OrgSettingsRow(
      orgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}org_id'])!,
      updatedAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
      laborRate: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}labor_rate'])!,
      taxEnabled: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tax_enabled'])!,
      taxRate: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tax_rate'])!,
      ccEnabled: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cc_enabled'])!,
      ccRate: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cc_rate'])!,
    );
  }
  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return {
      'org_id': Variable<String>(orgId),
      'updated_at': Variable<int>(updatedAt),
      'deleted': Variable<bool>(deleted),
      'labor_rate': Variable<double>(laborRate),
      'tax_enabled': Variable<bool>(taxEnabled),
      'tax_rate': Variable<double>(taxRate),
      'cc_enabled': Variable<bool>(ccEnabled),
      'cc_rate': Variable<double>(ccRate),
    };
  }
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
  const OrgSettingsTableCompanion({
    this.orgId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.laborRate = const Value.absent(),
    this.taxEnabled = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.ccEnabled = const Value.absent(),
    this.ccRate = const Value.absent(),
  });
}

class $OrgSettingsTableTable extends OrgSettingsTable
    with TableInfo<$OrgSettingsTableTable, OrgSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrgSettingsTableTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
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
  @override
  late final GeneratedColumn<bool> taxEnabled = GeneratedColumn<bool>(
    'tax_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
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
  @override
  late final GeneratedColumn<bool> ccEnabled = GeneratedColumn<bool>(
    'cc_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumn<double> ccRate = GeneratedColumn<double>(
    'cc_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.03),
  );
  @override
  List<GeneratedColumn> get $columns =>
      [orgId, updatedAt, deleted, laborRate, taxEnabled, taxRate, ccEnabled, ccRate];
  @override
  String get aliasedName => _alias ?? 'org_settings_table';
  @override
  String get actualTableName => 'org_settings_table';
  @override
  VerificationContext validateIntegrity(Insertable<OrgSettingsRow> instance,
      {bool isInserting = false}) {
    return VerificationContext();
  }
  @override
  OrgSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    return OrgSettingsRow.fromData(data, prefix: tablePrefix);
  }

  @override
  $OrgSettingsTableTable createAlias(String alias) {
    return $OrgSettingsTableTable(attachedDatabase, alias);
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
  factory OutboxRow.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return OutboxRow(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      entityType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}entity_type'])!,
      entityId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}entity_id'])!,
      opType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}op_type'])!,
      payload: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payload'])!,
      updatedAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      orgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}org_id'])!,
      status: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
    );
  }
  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return {
      'id': Variable<String>(id),
      'entity_type': Variable<String>(entityType),
      'entity_id': Variable<String>(entityId),
      'op_type': Variable<String>(opType),
      'payload': Variable<String>(payload),
      'updated_at': Variable<int>(updatedAt),
      'org_id': Variable<String>(orgId),
      'status': Variable<String>(status),
    };
  }
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
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.opType = const Value.absent(),
    this.payload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.orgId = const Value.absent(),
    this.status = const Value.absent(),
  });
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> opType = GeneratedColumn<String>(
    'op_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
  List<GeneratedColumn> get $columns =>
      [id, entityType, entityId, opType, payload, updatedAt, orgId, status];
  @override
  String get aliasedName => _alias ?? 'outbox';
  @override
  String get actualTableName => 'outbox';
  @override
  VerificationContext validateIntegrity(Insertable<OutboxRow> instance,
      {bool isInserting = false}) {
    return VerificationContext();
  }
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    return OutboxRow.fromData(data, prefix: tablePrefix);
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
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
  factory SyncStateRow.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return SyncStateRow(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      orgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}org_id'])!,
      lastSyncAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_sync_at'])!,
    );
  }
  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return {
      'id': Variable<String>(id),
      'org_id': Variable<String>(orgId),
      'last_sync_at': Variable<int>(lastSyncAt),
    };
  }
}

class SyncStateCompanion extends UpdateCompanion<SyncStateRow> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<int> lastSyncAt;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String id,
    required String orgId,
    Value<int> lastSyncAt = const Value.absent(),
  })  : id = Value(id),
        orgId = Value(orgId),
        lastSyncAt = lastSyncAt;
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  String get aliasedName => _alias ?? 'sync_state';
  @override
  String get actualTableName => 'sync_state';
  @override
  VerificationContext validateIntegrity(Insertable<SyncStateRow> instance,
      {bool isInserting = false}) {
    return VerificationContext();
  }
  @override
  SyncStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    return SyncStateRow.fromData(data, prefix: tablePrefix);
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $QuotesTable quotes = $QuotesTable(this);
  late final $QuoteItemsTable quoteItems = $QuoteItemsTable(this);
  late final $OrgSettingsTableTable orgSettingsTable =
      $OrgSettingsTableTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => [
        clients,
        quotes,
        quoteItems,
        orgSettingsTable,
        outbox,
        syncState,
      ];
}

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
    this.pricingProfileId = 'default',
    this.defaultRoomType = '',
    this.defaultLevel = '',
    this.defaultSize = '',
    this.defaultComplexity = '',
    this.subItemType = '',
    this.specialNotes = '',
    this.items = const [],
    this.pets = const [],
    this.householdMembers = const [],
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
  final String pricingProfileId;
  final String defaultRoomType;
  final String defaultLevel;
  final String defaultSize;
  final String defaultComplexity;
  final String subItemType;
  final String specialNotes;
  final List<Map<String, dynamic>> items;
  final List<Pet> pets;
  final List<HouseholdMember> householdMembers;
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
    this.pricingProfileId = 'default',
    this.defaultRoomType = '',
    this.defaultLevel = '',
    this.defaultSize = '',
    this.defaultComplexity = '',
    this.subItemType = '',
    this.specialNotes = '',
    this.items = const [],
    this.pets = const [],
    this.householdMembers = const [],
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
  final String pricingProfileId;
  final String defaultRoomType;
  final String defaultLevel;
  final String defaultSize;
  final String defaultComplexity;
  final String subItemType;
  final String specialNotes;
  final List<Map<String, dynamic>> items;
  final List<Pet> pets;
  final List<HouseholdMember> householdMembers;

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
        'pricingProfileId': pricingProfileId.trim(),
        'defaultRoomType': defaultRoomType.trim(),
        'defaultLevel': defaultLevel.trim(),
        'defaultSize': defaultSize.trim(),
        'defaultComplexity': defaultComplexity.trim(),
        'subItemType': subItemType.trim(),
        'specialNotes': specialNotes.trim(),
        'items': items,
        'pets': pets.map((pet) => pet.toMap()).toList(),
        'householdMembers':
            householdMembers.map((member) => member.toMap()).toList(),
      };
}

class Pet {
  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.notes,
    required this.excluded,
    required this.addedAt,
  });

  factory Pet.fromMap(Map<String, dynamic> data) {
    return Pet(
      id: (data['id'] as String?) ?? '',
      name: (data['name'] as String?) ?? '',
      type: (data['type'] as String?) ?? '',
      notes: (data['notes'] as String?) ?? '',
      excluded: (data['excluded'] as bool?) ?? false,
      addedAt: (data['addedAt'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String name;
  final String type;
  final String notes;
  final bool excluded;
  final int addedAt;

  Pet copyWith({
    String? id,
    String? name,
    String? type,
    String? notes,
    bool? excluded,
    int? addedAt,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      excluded: excluded ?? this.excluded,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name.trim(),
        'type': type.trim(),
        'notes': notes.trim(),
        'excluded': excluded,
        'addedAt': addedAt,
      };
}

class HouseholdMember {
  HouseholdMember({
    required this.id,
    required this.name,
    required this.relationship,
    required this.notes,
    required this.addedAt,
  });

  factory HouseholdMember.fromMap(Map<String, dynamic> data) {
    return HouseholdMember(
      id: (data['id'] as String?) ?? '',
      name: (data['name'] as String?) ?? '',
      relationship: (data['relationship'] as String?) ?? '',
      notes: (data['notes'] as String?) ?? '',
      addedAt: (data['addedAt'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String name;
  final String relationship;
  final String notes;
  final int addedAt;

  HouseholdMember copyWith({
    String? id,
    String? name,
    String? relationship,
    String? notes,
    int? addedAt,
  }) {
    return HouseholdMember(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      notes: notes ?? this.notes,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name.trim(),
        'relationship': relationship.trim(),
        'notes': notes.trim(),
        'addedAt': addedAt,
      };
}

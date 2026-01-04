class PricingProfileHeader {
  PricingProfileHeader({
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
}

class PricingProfileServiceType {
  PricingProfileServiceType({
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
}

class PricingProfileFrequency {
  PricingProfileFrequency({
    required this.id,
    required this.orgId,
    required this.profileId,
    required this.serviceType,
    required this.frequency,
    required this.multiplier,
    required this.updatedAt,
    required this.deleted,
  });

  final String id;
  final String orgId;
  final String profileId;
  final String serviceType;
  final String frequency;
  final double multiplier;
  final int updatedAt;
  final bool deleted;
}

class PricingProfileRoomType {
  PricingProfileRoomType({
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
}

class PricingProfileSubItem {
  PricingProfileSubItem({
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

  final String id;
  final String orgId;
  final String profileId;
  final String category;
  final String subItem;
  final String description;
  final int minutes;
  final int updatedAt;
  final bool deleted;
}

class PricingProfileSize {
  PricingProfileSize({
    required this.id,
    required this.orgId,
    required this.profileId,
    required this.size,
    required this.multiplier,
    required this.definition,
    required this.updatedAt,
    required this.deleted,
  });

  final String id;
  final String orgId;
  final String profileId;
  final String size;
  final double multiplier;
  final String definition;
  final int updatedAt;
  final bool deleted;
}

class PricingProfileComplexity {
  PricingProfileComplexity({
    required this.id,
    required this.orgId,
    required this.profileId,
    required this.level,
    required this.multiplier,
    required this.definition,
    required this.updatedAt,
    required this.deleted,
  });

  final String id;
  final String orgId;
  final String profileId;
  final String level;
  final double multiplier;
  final String definition;
  final int updatedAt;
  final bool deleted;
}

class PricingProfileCatalog {
  PricingProfileCatalog({
    required this.serviceTypes,
    required this.frequencies,
    required this.roomTypes,
    required this.subItems,
    required this.sizes,
    required this.complexities,
  });

  factory PricingProfileCatalog.empty() {
    return PricingProfileCatalog(
      serviceTypes: const [],
      frequencies: const [],
      roomTypes: const [],
      subItems: const [],
      sizes: const [],
      complexities: const [],
    );
  }

  final List<PricingProfileServiceType> serviceTypes;
  final List<PricingProfileFrequency> frequencies;
  final List<PricingProfileRoomType> roomTypes;
  final List<PricingProfileSubItem> subItems;
  final List<PricingProfileSize> sizes;
  final List<PricingProfileComplexity> complexities;
}

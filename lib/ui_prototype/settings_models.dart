part of '../ui_prototype.dart';

class PlanTier {
  const PlanTier({
    required this.name,
    required this.label,
    required this.color,
    required this.multiplier,
    required this.description,
  });

  factory PlanTier.fromJson(Map<String, dynamic> json) {
    return PlanTier(
      name: json['name'] as String,
      label: json['label'] as String,
      color: _parseColor(json['color'] as String),
      multiplier: (json['multiplier'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  final String name;
  final String label;
  final Color color;
  final double multiplier;
  final String description;
}

class ServiceTypeStandard {
  const ServiceTypeStandard({
    required this.row,
    required this.category,
    required this.serviceType,
    required this.description,
    required this.pricePerSqFt,
    required this.multiplier,
  });

  factory ServiceTypeStandard.fromJson(Map<String, dynamic> json) {
    return ServiceTypeStandard(
      row: (json['row'] as num?)?.toInt() ?? 0,
      category: (json['category'] as String?) ?? 'General',
      serviceType: json['serviceType'] as String,
      description: (json['description'] as String?) ?? '',
      pricePerSqFt: (json['pricePerSqFt'] as num).toDouble(),
      multiplier: (json['multiplier'] as num).toDouble(),
    );
  }

  final int row;
  final String category;
  final String serviceType;
  final String description;
  final double pricePerSqFt;
  final double multiplier;
}

class ComplexityStandard {
  const ComplexityStandard({
    required this.level,
    required this.multiplier,
    required this.definition,
  });

  factory ComplexityStandard.fromJson(Map<String, dynamic> json) {
    return ComplexityStandard(
      level: json['level'] as String,
      multiplier: (json['multiplier'] as num).toDouble(),
      definition: json['definition'] as String,
    );
  }

  final String level;
  final double multiplier;
  final String definition;
}

class SizeStandard {
  const SizeStandard({
    required this.size,
    required this.multiplier,
    required this.definition,
  });

  factory SizeStandard.fromJson(Map<String, dynamic> json) {
    return SizeStandard(
      size: json['size'] as String,
      multiplier: (json['multiplier'] as num).toDouble(),
      definition: json['definition'] as String,
    );
  }

  final String size;
  final double multiplier;
  final String definition;
}

class FrequencyStandard {
  const FrequencyStandard({
    required this.serviceType,
    required this.multiplier,
    required this.frequency,
  });

  factory FrequencyStandard.fromJson(Map<String, dynamic> json) {
    return FrequencyStandard(
      serviceType: json['serviceType'] as String,
      multiplier: (json['multiplier'] as num).toDouble(),
      frequency: json['frequency'] as String,
    );
  }

  final String serviceType;
  final double multiplier;
  final String frequency;
}

class RoomTypeStandard {
  const RoomTypeStandard({
    required this.row,
    required this.category,
    required this.roomType,
    required this.description,
    required this.minutes,
    required this.squareFeet,
  });

  factory RoomTypeStandard.fromJson(Map<String, dynamic> json) {
    return RoomTypeStandard(
      row: (json['row'] as num?)?.toInt() ?? 0,
      category: (json['category'] as String?) ?? 'General',
      roomType: json['roomType'] as String,
      description: (json['description'] as String?) ?? '',
      minutes: (json['minutes'] as num).toInt(),
      squareFeet: (json['squareFeet'] as num).toInt(),
    );
  }

  final int row;
  final String category;
  final String roomType;
  final String description;
  final int minutes;
  final int squareFeet;
}

class SubItemStandard {
  const SubItemStandard({
    required this.category,
    required this.subItem,
    required this.description,
    required this.minutes,
  });

  factory SubItemStandard.fromJson(Map<String, dynamic> json) {
    return SubItemStandard(
      category: (json['category'] as String?) ?? 'General',
      subItem: json['subItem'] as String,
      description: (json['description'] as String?) ?? '',
      minutes: (json['minutes'] as num).toInt(),
    );
  }

  final String category;
  final String subItem;
  final String description;
  final int minutes;
}

class SettingsData {
  SettingsData({
    required this.planTiers,
    required this.serviceTypes,
    required this.complexities,
    required this.sizes,
    required this.frequencies,
    required this.roomTypes,
    required this.subItems,
  });

  factory SettingsData.empty() {
    return SettingsData(
      planTiers: const [],
      serviceTypes: const [],
      complexities: const [],
      sizes: const [],
      frequencies: const [],
      roomTypes: const [],
      subItems: const [],
    );
  }

  final List<PlanTier> planTiers;
  final List<ServiceTypeStandard> serviceTypes;
  final List<ComplexityStandard> complexities;
  final List<SizeStandard> sizes;
  final List<FrequencyStandard> frequencies;
  final List<RoomTypeStandard> roomTypes;
  final List<SubItemStandard> subItems;
}

Color _parseColor(String value) {
  final hex = value.replaceAll('#', '');
  final buffer = StringBuffer();
  if (hex.length == 6) {
    buffer.write('ff');
  }
  buffer.write(hex);
  return Color(int.parse(buffer.toString(), radix: 16));
}

extension on OrgSettings {
  OrgSettings copyWith({
    double? laborRate,
    bool? taxEnabled,
    double? taxRate,
    bool? ccEnabled,
    double? ccRate,
    String? defaultPricingProfileId,
  }) {
    return OrgSettings(
      laborRate: laborRate ?? this.laborRate,
      taxEnabled: taxEnabled ?? this.taxEnabled,
      taxRate: taxRate ?? this.taxRate,
      ccEnabled: ccEnabled ?? this.ccEnabled,
      ccRate: ccRate ?? this.ccRate,
      defaultPricingProfileId:
          defaultPricingProfileId ?? this.defaultPricingProfileId,
    );
  }
}

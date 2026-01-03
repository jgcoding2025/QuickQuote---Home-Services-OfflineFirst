part of '../ui_prototype.dart';

class _PlanTier {
  const _PlanTier({
    required this.name,
    required this.label,
    required this.color,
    required this.multiplier,
    required this.description,
  });

  factory _PlanTier.fromJson(Map<String, dynamic> json) {
    return _PlanTier(
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

class _ServiceTypeStandard {
  const _ServiceTypeStandard({
    required this.row,
    required this.category,
    required this.serviceType,
    required this.description,
    required this.pricePerSqFt,
    required this.multiplier,
  });

  factory _ServiceTypeStandard.fromJson(Map<String, dynamic> json) {
    return _ServiceTypeStandard(
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

class _ComplexityStandard {
  const _ComplexityStandard({
    required this.level,
    required this.multiplier,
    required this.definition,
  });

  factory _ComplexityStandard.fromJson(Map<String, dynamic> json) {
    return _ComplexityStandard(
      level: json['level'] as String,
      multiplier: (json['multiplier'] as num).toDouble(),
      definition: json['definition'] as String,
    );
  }

  final String level;
  final double multiplier;
  final String definition;
}

class _SizeStandard {
  const _SizeStandard({
    required this.size,
    required this.multiplier,
    required this.definition,
  });

  factory _SizeStandard.fromJson(Map<String, dynamic> json) {
    return _SizeStandard(
      size: json['size'] as String,
      multiplier: (json['multiplier'] as num).toDouble(),
      definition: json['definition'] as String,
    );
  }

  final String size;
  final double multiplier;
  final String definition;
}

class _FrequencyStandard {
  const _FrequencyStandard({
    required this.serviceType,
    required this.multiplier,
    required this.frequency,
  });

  factory _FrequencyStandard.fromJson(Map<String, dynamic> json) {
    return _FrequencyStandard(
      serviceType: json['serviceType'] as String,
      multiplier: (json['multiplier'] as num).toDouble(),
      frequency: json['frequency'] as String,
    );
  }

  final String serviceType;
  final double multiplier;
  final String frequency;
}

class _RoomTypeStandard {
  const _RoomTypeStandard({
    required this.row,
    required this.category,
    required this.roomType,
    required this.description,
    required this.minutes,
    required this.squareFeet,
  });

  factory _RoomTypeStandard.fromJson(Map<String, dynamic> json) {
    return _RoomTypeStandard(
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

class _SubItemStandard {
  const _SubItemStandard({
    required this.category,
    required this.subItem,
    required this.description,
    required this.minutes,
  });

  factory _SubItemStandard.fromJson(Map<String, dynamic> json) {
    return _SubItemStandard(
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

class _SettingsData {
  _SettingsData({
    required this.planTiers,
    required this.serviceTypes,
    required this.complexities,
    required this.sizes,
    required this.frequencies,
    required this.roomTypes,
    required this.subItems,
  });

  factory _SettingsData.empty() {
    return _SettingsData(
      planTiers: const [],
      serviceTypes: const [],
      complexities: const [],
      sizes: const [],
      frequencies: const [],
      roomTypes: const [],
      subItems: const [],
    );
  }

  final List<_PlanTier> planTiers;
  final List<_ServiceTypeStandard> serviceTypes;
  final List<_ComplexityStandard> complexities;
  final List<_SizeStandard> sizes;
  final List<_FrequencyStandard> frequencies;
  final List<_RoomTypeStandard> roomTypes;
  final List<_SubItemStandard> subItems;
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
  }) {
    return OrgSettings(
      laborRate: laborRate ?? this.laborRate,
      taxEnabled: taxEnabled ?? this.taxEnabled,
      taxRate: taxRate ?? this.taxRate,
      ccEnabled: ccEnabled ?? this.ccEnabled,
      ccRate: ccRate ?? this.ccRate,
    );
  }
}

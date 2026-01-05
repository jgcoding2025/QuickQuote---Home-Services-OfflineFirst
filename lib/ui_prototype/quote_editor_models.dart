part of '../ui_prototype.dart';

class _QuoteItem {
  final String type; // Room | Addon | Manual
  final String level;
  final String title;
  final String size;
  final String complexity;
  final int estSqFt;
  final int minutes;
  final int qty;
  final bool include;
  final String notes;
  final String roomAssignment;

  _QuoteItem(
    this.type,
    this.level,
    this.title,
    this.size,
    this.complexity,
    this.estSqFt,
    this.minutes,
    this.qty,
    this.include,
    this.notes,
    this.roomAssignment,
  );

  factory _QuoteItem.fromMap(Map<String, dynamic> data) {
    return _QuoteItem(
      (data['type'] as String?) ?? 'Room',
      (data['level'] as String?) ?? '',
      (data['title'] as String?) ?? '',
      (data['size'] as String?) ?? '',
      (data['complexity'] as String?) ?? '',
      (data['estSqFt'] as num?)?.toInt() ?? 0,
      (data['minutes'] as num?)?.toInt() ?? 0,
      (data['qty'] as num?)?.toInt() ?? 1,
      (data['include'] as bool?) ?? true,
      (data['notes'] as String?) ?? '',
      (data['roomAssignment'] as String?) ?? '',
    );
  }

  _QuoteItem copyWith({
    String? type,
    String? level,
    String? title,
    String? size,
    String? complexity,
    int? estSqFt,
    int? minutes,
    int? qty,
    bool? include,
    String? notes,
    String? roomAssignment,
  }) => _QuoteItem(
    type ?? this.type,
    level ?? this.level,
    title ?? this.title,
    size ?? this.size,
    complexity ?? this.complexity,
    estSqFt ?? this.estSqFt,
    minutes ?? this.minutes,
    qty ?? this.qty,
    include ?? this.include,
    notes ?? this.notes,
    roomAssignment ?? this.roomAssignment,
  );

  Map<String, dynamic> toMap() => {
    'type': type,
    'level': level,
    'title': title,
    'size': size,
    'complexity': complexity,
    'estSqFt': estSqFt,
    'minutes': minutes,
    'qty': qty,
    'include': include,
    'notes': notes,
    'roomAssignment': roomAssignment,
  };
}

class _Totals {
  final double minutes;
  final double hours;
  final double subtotal;
  final double tax;
  final double ccFee;
  final double total;

  _Totals(
    this.minutes,
    this.hours,
    this.subtotal,
    this.tax,
    this.ccFee,
    this.total,
  );
}

class _QuoteSettingsData {
  const _QuoteSettingsData({
    required this.serviceTypes,
    required this.frequencies,
    required this.roomTypes,
    required this.subItems,
    required this.sizes,
    required this.complexities,
    required this.occupantsRules,
  });

  factory _QuoteSettingsData.empty() {
    return const _QuoteSettingsData(
      serviceTypes: [],
      frequencies: [],
      roomTypes: [],
      subItems: [],
      sizes: [],
      complexities: [],
      occupantsRules: OccupantsRules.defaults,
    );
  }

  final List<ServiceTypeStandard> serviceTypes;
  final List<FrequencyStandard> frequencies;
  final List<RoomTypeStandard> roomTypes;
  final List<SubItemStandard> subItems;
  final List<SizeStandard> sizes;
  final List<ComplexityStandard> complexities;
  final OccupantsRules occupantsRules;
}

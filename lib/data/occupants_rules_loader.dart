import 'dart:convert';

import 'package:flutter/services.dart';

class OccupantsRules {
  const OccupantsRules({
    required this.petMinutesDefault,
    required this.householdFreeCount,
    required this.householdExtraMinutesPerPerson,
  });

  factory OccupantsRules.fromJson(Map<String, dynamic> data) {
    return OccupantsRules(
      petMinutesDefault: (data['petMinutesDefault'] as num?)?.toInt() ?? 15,
      householdFreeCount: (data['householdFreeCount'] as num?)?.toInt() ?? 4,
      householdExtraMinutesPerPerson:
          (data['householdExtraMinutesPerPerson'] as num?)?.toInt() ?? 15,
    );
  }

  static const OccupantsRules defaults = OccupantsRules(
    petMinutesDefault: 15,
    householdFreeCount: 4,
    householdExtraMinutesPerPerson: 15,
  );

  final int petMinutesDefault;
  final int householdFreeCount;
  final int householdExtraMinutesPerPerson;
}

class OccupantsRulesLoader {
  static OccupantsRules? _cached;

  static Future<OccupantsRules> load() async {
    if (_cached != null) {
      return _cached!;
    }
    try {
      final content = await rootBundle.loadString(
        'assets/occupants_rules.json',
      );
      final decoded = jsonDecode(content);
      if (decoded is Map<String, dynamic>) {
        _cached = OccupantsRules.fromJson(decoded);
        return _cached!;
      }
    } catch (_) {}
    _cached = OccupantsRules.defaults;
    return _cached!;
  }
}

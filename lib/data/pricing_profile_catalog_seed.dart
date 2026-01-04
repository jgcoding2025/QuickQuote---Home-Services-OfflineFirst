import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'local_db.dart';

typedef PricingProfileOutboxInsert = Future<void> Function({
  required String entityType,
  required String entityId,
  required String opType,
  required Map<String, dynamic> payload,
  required String orgId,
  required int updatedAt,
});

class PricingProfileCatalogSeeder {
  PricingProfileCatalogSeeder({
    required AppDatabase db,
    required Uuid uuid,
    required PricingProfileOutboxInsert insertOutbox,
  })  : _db = db,
        _uuid = uuid,
        _insertOutbox = insertOutbox;

  final AppDatabase _db;
  final Uuid _uuid;
  final PricingProfileOutboxInsert _insertOutbox;

  Future<PricingProfileSeedData> loadSeedData() async {
    final serviceTypes = await _loadAssetList(
      'assets/settings/service_type_standards.json',
    );
    final frequencies = await _loadAssetList(
      'assets/settings/frequency_standards.json',
    );
    final roomTypes = await _loadAssetList(
      'assets/settings/room_type_standards.json',
    );
    final subItems = await _loadAssetList(
      'assets/settings/sub_item_standards.json',
    );
    final sizes = await _loadAssetList(
      'assets/settings/size_standards.json',
    );
    final complexities = await _loadAssetList(
      'assets/settings/complexity_standards.json',
    );

    return PricingProfileSeedData(
      serviceTypes: serviceTypes,
      frequencies: frequencies,
      roomTypes: roomTypes,
      subItems: subItems,
      sizes: sizes,
      complexities: complexities,
    );
  }

  Future<void> insertCatalogRows({
    required String orgId,
    required String profileId,
    required int updatedAt,
    required PricingProfileSeedData data,
  }) async {
    await _insertServiceTypes(
      orgId: orgId,
      profileId: profileId,
      updatedAt: updatedAt,
      items: data.serviceTypes,
    );
    await _insertFrequencies(
      orgId: orgId,
      profileId: profileId,
      updatedAt: updatedAt,
      items: data.frequencies,
    );
    await _insertRoomTypes(
      orgId: orgId,
      profileId: profileId,
      updatedAt: updatedAt,
      items: data.roomTypes,
    );
    await _insertSubItems(
      orgId: orgId,
      profileId: profileId,
      updatedAt: updatedAt,
      items: data.subItems,
    );
    await _insertSizes(
      orgId: orgId,
      profileId: profileId,
      updatedAt: updatedAt,
      items: data.sizes,
    );
    await _insertComplexities(
      orgId: orgId,
      profileId: profileId,
      updatedAt: updatedAt,
      items: data.complexities,
    );
  }

  Future<List<Map<String, dynamic>>> _loadAssetList(String path) async {
    final content = await rootBundle.loadString(path);
    final data = jsonDecode(content);
    if (data is! List) {
      return const [];
    }
    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> _insertServiceTypes({
    required String orgId,
    required String profileId,
    required int updatedAt,
    required List<Map<String, dynamic>> items,
  }) async {
    for (final item in items) {
      final id = _uuid.v4();
      await _db.into(_db.pricingProfileServiceTypes).insert(
            PricingProfileServiceTypesCompanion(
              id: Value(id),
              orgId: Value(orgId),
              profileId: Value(profileId),
              row: Value((item['row'] as num?)?.toInt() ?? 0),
              category: Value((item['category'] as String?) ?? 'General'),
              serviceType: Value(item['serviceType'] as String? ?? ''),
              description: Value((item['description'] as String?) ?? ''),
              pricePerSqFt:
                  Value((item['pricePerSqFt'] as num?)?.toDouble() ?? 0),
              multiplier:
                  Value((item['multiplier'] as num?)?.toDouble() ?? 1),
              updatedAt: Value(updatedAt),
              deleted: const Value(false),
            ),
          );
      await _insertOutbox(
        entityType: 'pricing_profile_service_type',
        entityId: id,
        opType: 'create',
        payload: {
          'id': id,
          'orgId': orgId,
          'profileId': profileId,
          'row': (item['row'] as num?)?.toInt() ?? 0,
          'category': (item['category'] as String?) ?? 'General',
          'serviceType': item['serviceType'] as String? ?? '',
          'description': (item['description'] as String?) ?? '',
          'pricePerSqFt':
              (item['pricePerSqFt'] as num?)?.toDouble() ?? 0,
          'multiplier': (item['multiplier'] as num?)?.toDouble() ?? 1,
          'updatedAt': updatedAt,
          'deleted': false,
        },
        orgId: orgId,
        updatedAt: updatedAt,
      );
    }
  }

  Future<void> _insertFrequencies({
    required String orgId,
    required String profileId,
    required int updatedAt,
    required List<Map<String, dynamic>> items,
  }) async {
    for (final item in items) {
      final id = _uuid.v4();
      await _db.into(_db.pricingProfileFrequencies).insert(
            PricingProfileFrequenciesCompanion(
              id: Value(id),
              orgId: Value(orgId),
              profileId: Value(profileId),
              serviceType: Value(item['serviceType'] as String? ?? ''),
              frequency: Value(item['frequency'] as String? ?? ''),
              multiplier:
                  Value((item['multiplier'] as num?)?.toDouble() ?? 1),
              updatedAt: Value(updatedAt),
              deleted: const Value(false),
            ),
          );
      await _insertOutbox(
        entityType: 'pricing_profile_frequency',
        entityId: id,
        opType: 'create',
        payload: {
          'id': id,
          'orgId': orgId,
          'profileId': profileId,
          'serviceType': item['serviceType'] as String? ?? '',
          'frequency': item['frequency'] as String? ?? '',
          'multiplier': (item['multiplier'] as num?)?.toDouble() ?? 1,
          'updatedAt': updatedAt,
          'deleted': false,
        },
        orgId: orgId,
        updatedAt: updatedAt,
      );
    }
  }

  Future<void> _insertRoomTypes({
    required String orgId,
    required String profileId,
    required int updatedAt,
    required List<Map<String, dynamic>> items,
  }) async {
    for (final item in items) {
      final id = _uuid.v4();
      await _db.into(_db.pricingProfileRoomTypes).insert(
            PricingProfileRoomTypesCompanion(
              id: Value(id),
              orgId: Value(orgId),
              profileId: Value(profileId),
              row: Value((item['row'] as num?)?.toInt() ?? 0),
              category: Value((item['category'] as String?) ?? 'General'),
              roomType: Value(item['roomType'] as String? ?? ''),
              description: Value((item['description'] as String?) ?? ''),
              minutes: Value((item['minutes'] as num?)?.toInt() ?? 0),
              squareFeet:
                  Value((item['squareFeet'] as num?)?.toInt() ?? 0),
              updatedAt: Value(updatedAt),
              deleted: const Value(false),
            ),
          );
      await _insertOutbox(
        entityType: 'pricing_profile_room_type',
        entityId: id,
        opType: 'create',
        payload: {
          'id': id,
          'orgId': orgId,
          'profileId': profileId,
          'row': (item['row'] as num?)?.toInt() ?? 0,
          'category': (item['category'] as String?) ?? 'General',
          'roomType': item['roomType'] as String? ?? '',
          'description': (item['description'] as String?) ?? '',
          'minutes': (item['minutes'] as num?)?.toInt() ?? 0,
          'squareFeet': (item['squareFeet'] as num?)?.toInt() ?? 0,
          'updatedAt': updatedAt,
          'deleted': false,
        },
        orgId: orgId,
        updatedAt: updatedAt,
      );
    }
  }

  Future<void> _insertSubItems({
    required String orgId,
    required String profileId,
    required int updatedAt,
    required List<Map<String, dynamic>> items,
  }) async {
    for (final item in items) {
      final id = _uuid.v4();
      await _db.into(_db.pricingProfileSubItems).insert(
            PricingProfileSubItemsCompanion(
              id: Value(id),
              orgId: Value(orgId),
              profileId: Value(profileId),
              category: Value((item['category'] as String?) ?? 'General'),
              subItem: Value(item['subItem'] as String? ?? ''),
              description: Value((item['description'] as String?) ?? ''),
              minutes: Value((item['minutes'] as num?)?.toInt() ?? 0),
              updatedAt: Value(updatedAt),
              deleted: const Value(false),
            ),
          );
      await _insertOutbox(
        entityType: 'pricing_profile_sub_item',
        entityId: id,
        opType: 'create',
        payload: {
          'id': id,
          'orgId': orgId,
          'profileId': profileId,
          'category': (item['category'] as String?) ?? 'General',
          'subItem': item['subItem'] as String? ?? '',
          'description': (item['description'] as String?) ?? '',
          'minutes': (item['minutes'] as num?)?.toInt() ?? 0,
          'updatedAt': updatedAt,
          'deleted': false,
        },
        orgId: orgId,
        updatedAt: updatedAt,
      );
    }
  }

  Future<void> _insertSizes({
    required String orgId,
    required String profileId,
    required int updatedAt,
    required List<Map<String, dynamic>> items,
  }) async {
    for (final item in items) {
      final id = _uuid.v4();
      await _db.into(_db.pricingProfileSizes).insert(
            PricingProfileSizesCompanion(
              id: Value(id),
              orgId: Value(orgId),
              profileId: Value(profileId),
              size: Value(item['size'] as String? ?? ''),
              multiplier:
                  Value((item['multiplier'] as num?)?.toDouble() ?? 1),
              definition: Value((item['definition'] as String?) ?? ''),
              updatedAt: Value(updatedAt),
              deleted: const Value(false),
            ),
          );
      await _insertOutbox(
        entityType: 'pricing_profile_size',
        entityId: id,
        opType: 'create',
        payload: {
          'id': id,
          'orgId': orgId,
          'profileId': profileId,
          'size': item['size'] as String? ?? '',
          'multiplier': (item['multiplier'] as num?)?.toDouble() ?? 1,
          'definition': (item['definition'] as String?) ?? '',
          'updatedAt': updatedAt,
          'deleted': false,
        },
        orgId: orgId,
        updatedAt: updatedAt,
      );
    }
  }

  Future<void> _insertComplexities({
    required String orgId,
    required String profileId,
    required int updatedAt,
    required List<Map<String, dynamic>> items,
  }) async {
    for (final item in items) {
      final id = _uuid.v4();
      await _db.into(_db.pricingProfileComplexities).insert(
            PricingProfileComplexitiesCompanion(
              id: Value(id),
              orgId: Value(orgId),
              profileId: Value(profileId),
              level: Value(item['level'] as String? ?? ''),
              multiplier:
                  Value((item['multiplier'] as num?)?.toDouble() ?? 1),
              definition: Value((item['definition'] as String?) ?? ''),
              updatedAt: Value(updatedAt),
              deleted: const Value(false),
            ),
          );
      await _insertOutbox(
        entityType: 'pricing_profile_complexity',
        entityId: id,
        opType: 'create',
        payload: {
          'id': id,
          'orgId': orgId,
          'profileId': profileId,
          'level': item['level'] as String? ?? '',
          'multiplier': (item['multiplier'] as num?)?.toDouble() ?? 1,
          'definition': (item['definition'] as String?) ?? '',
          'updatedAt': updatedAt,
          'deleted': false,
        },
        orgId: orgId,
        updatedAt: updatedAt,
      );
    }
  }
}

class PricingProfileSeedData {
  PricingProfileSeedData({
    required this.serviceTypes,
    required this.frequencies,
    required this.roomTypes,
    required this.subItems,
    required this.sizes,
    required this.complexities,
  });

  final List<Map<String, dynamic>> serviceTypes;
  final List<Map<String, dynamic>> frequencies;
  final List<Map<String, dynamic>> roomTypes;
  final List<Map<String, dynamic>> subItems;
  final List<Map<String, dynamic>> sizes;
  final List<Map<String, dynamic>> complexities;
}

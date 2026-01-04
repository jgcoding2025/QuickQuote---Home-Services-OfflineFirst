import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'local_db.dart';
import 'org_settings_models.dart';
import 'pricing_profile_models.dart';
import 'session_controller.dart';
import 'sync_service.dart';

class PricingProfilesRepositoryLocalFirst {
  PricingProfilesRepositoryLocalFirst({
    required AppDatabase db,
    required SessionController sessionController,
    required SyncService syncService,
    Uuid? uuid,
  }) : _db = db,
       _sessionController = sessionController,
       _syncService = syncService,
       _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final SessionController _sessionController;
  final SyncService _syncService;
  final Uuid _uuid;

  Stream<List<PricingProfileHeader>> streamProfiles() {
    final controller =
        StreamController<List<PricingProfileHeader>>.broadcast();
    StreamSubscription<List<PricingProfileHeader>>? dataSub;
    List<PricingProfileHeader> last = const [];

    void emitProfiles(List<PricingProfileHeader> profiles) {
      last = profiles;
      if (!controller.isClosed) {
        controller.add(profiles);
      }
    }

    void listenSession(AppSession? session) {
      dataSub?.cancel();
      if (session == null || session.orgId == null) {
        if (last.isEmpty) {
          emitProfiles(const []);
        }
        return;
      }
      dataSub =
          (_db.select(_db.pricingProfiles)
                ..where(
                  (tbl) =>
                      tbl.orgId.equals(session.orgId!) &
                      tbl.deleted.equals(false),
                )
                ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
              .watch()
              .map((rows) => rows.map(_mapHeader).toList())
              .listen(emitProfiles, onError: controller.addError);
    }

    listenSession(_sessionController.value);
    final sessionSub = _sessionController.stream.listen(listenSession);

    controller.onCancel = () async {
      await dataSub?.cancel();
      await sessionSub.cancel();
    };

    return controller.stream;
  }

  Future<PricingProfileHeader?> getProfileById(String profileId) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      return null;
    }
    final row =
        await (_db.select(_db.pricingProfiles)
              ..where(
                (tbl) => tbl.orgId.equals(orgId) & tbl.id.equals(profileId),
              )
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _mapHeader(row);
  }

  Future<PricingProfileHeader> createProfileByDuplicatingDefault(
    String name,
  ) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final newId = _uuid.v4();
    final orgSettings = await _loadOrgSettings(orgId);
    final defaultProfileId =
        orgSettings.defaultPricingProfileId.isEmpty
            ? 'default'
            : orgSettings.defaultPricingProfileId;
    final serviceTypes =
        await (_db.select(_db.pricingProfileServiceTypes)
              ..where(
                (tbl) =>
                    tbl.orgId.equals(orgId) &
                    tbl.profileId.equals(defaultProfileId) &
                    tbl.deleted.equals(false),
              ))
            .get();
    final frequencies =
        await (_db.select(_db.pricingProfileFrequencies)
              ..where(
                (tbl) =>
                    tbl.orgId.equals(orgId) &
                    tbl.profileId.equals(defaultProfileId) &
                    tbl.deleted.equals(false),
              ))
            .get();
    final roomTypes =
        await (_db.select(_db.pricingProfileRoomTypes)
              ..where(
                (tbl) =>
                    tbl.orgId.equals(orgId) &
                    tbl.profileId.equals(defaultProfileId) &
                    tbl.deleted.equals(false),
              ))
            .get();
    final subItems =
        await (_db.select(_db.pricingProfileSubItems)
              ..where(
                (tbl) =>
                    tbl.orgId.equals(orgId) &
                    tbl.profileId.equals(defaultProfileId) &
                    tbl.deleted.equals(false),
              ))
            .get();
    final sizes =
        await (_db.select(_db.pricingProfileSizes)
              ..where(
                (tbl) =>
                    tbl.orgId.equals(orgId) &
                    tbl.profileId.equals(defaultProfileId) &
                    tbl.deleted.equals(false),
              ))
            .get();
    final complexities =
        await (_db.select(_db.pricingProfileComplexities)
              ..where(
                (tbl) =>
                    tbl.orgId.equals(orgId) &
                    tbl.profileId.equals(defaultProfileId) &
                    tbl.deleted.equals(false),
              ))
            .get();
    final profileRow = PricingProfilesCompanion(
      id: Value(newId),
      orgId: Value(orgId),
      name: Value(name.trim().isEmpty ? 'Custom Profile' : name.trim()),
      laborRate: Value(orgSettings.laborRate),
      taxEnabled: Value(orgSettings.taxEnabled),
      taxRate: Value(orgSettings.taxRate),
      ccEnabled: Value(orgSettings.ccEnabled),
      ccRate: Value(orgSettings.ccRate),
      updatedAt: Value(now),
      deleted: const Value(false),
    );
    final serviceTypeRows = <PricingProfileServiceTypesCompanion>[];
    final serviceTypePayloads = <Map<String, dynamic>>[];
    for (final row in serviceTypes) {
      final id = _uuid.v4();
      serviceTypeRows.add(
        PricingProfileServiceTypesCompanion(
          id: Value(id),
          orgId: Value(orgId),
          profileId: Value(newId),
          row: Value(row.row),
          category: Value(row.category),
          serviceType: Value(row.serviceType),
          description: Value(row.description),
          pricePerSqFt: Value(row.pricePerSqFt),
          multiplier: Value(row.multiplier),
          updatedAt: Value(now),
          deleted: const Value(false),
        ),
      );
      serviceTypePayloads.add({
        'id': id,
        'orgId': orgId,
        'profileId': newId,
        'row': row.row,
        'category': row.category,
        'serviceType': row.serviceType,
        'description': row.description,
        'pricePerSqFt': row.pricePerSqFt,
        'multiplier': row.multiplier,
        'updatedAt': now,
        'deleted': false,
      });
    }
    final frequencyRows = <PricingProfileFrequenciesCompanion>[];
    final frequencyPayloads = <Map<String, dynamic>>[];
    for (final row in frequencies) {
      final id = _uuid.v4();
      frequencyRows.add(
        PricingProfileFrequenciesCompanion(
          id: Value(id),
          orgId: Value(orgId),
          profileId: Value(newId),
          serviceType: Value(row.serviceType),
          frequency: Value(row.frequency),
          multiplier: Value(row.multiplier),
          updatedAt: Value(now),
          deleted: const Value(false),
        ),
      );
      frequencyPayloads.add({
        'id': id,
        'orgId': orgId,
        'profileId': newId,
        'serviceType': row.serviceType,
        'frequency': row.frequency,
        'multiplier': row.multiplier,
        'updatedAt': now,
        'deleted': false,
      });
    }
    final roomTypeRows = <PricingProfileRoomTypesCompanion>[];
    final roomTypePayloads = <Map<String, dynamic>>[];
    for (final row in roomTypes) {
      final id = _uuid.v4();
      roomTypeRows.add(
        PricingProfileRoomTypesCompanion(
          id: Value(id),
          orgId: Value(orgId),
          profileId: Value(newId),
          row: Value(row.row),
          category: Value(row.category),
          roomType: Value(row.roomType),
          description: Value(row.description),
          minutes: Value(row.minutes),
          squareFeet: Value(row.squareFeet),
          updatedAt: Value(now),
          deleted: const Value(false),
        ),
      );
      roomTypePayloads.add({
        'id': id,
        'orgId': orgId,
        'profileId': newId,
        'row': row.row,
        'category': row.category,
        'roomType': row.roomType,
        'description': row.description,
        'minutes': row.minutes,
        'squareFeet': row.squareFeet,
        'updatedAt': now,
        'deleted': false,
      });
    }
    final subItemRows = <PricingProfileSubItemsCompanion>[];
    final subItemPayloads = <Map<String, dynamic>>[];
    for (final row in subItems) {
      final id = _uuid.v4();
      subItemRows.add(
        PricingProfileSubItemsCompanion(
          id: Value(id),
          orgId: Value(orgId),
          profileId: Value(newId),
          category: Value(row.category),
          subItem: Value(row.subItem),
          description: Value(row.description),
          minutes: Value(row.minutes),
          updatedAt: Value(now),
          deleted: const Value(false),
        ),
      );
      subItemPayloads.add({
        'id': id,
        'orgId': orgId,
        'profileId': newId,
        'category': row.category,
        'subItem': row.subItem,
        'description': row.description,
        'minutes': row.minutes,
        'updatedAt': now,
        'deleted': false,
      });
    }
    final sizeRows = <PricingProfileSizesCompanion>[];
    final sizePayloads = <Map<String, dynamic>>[];
    for (final row in sizes) {
      final id = _uuid.v4();
      sizeRows.add(
        PricingProfileSizesCompanion(
          id: Value(id),
          orgId: Value(orgId),
          profileId: Value(newId),
          size: Value(row.size),
          multiplier: Value(row.multiplier),
          definition: Value(row.definition),
          updatedAt: Value(now),
          deleted: const Value(false),
        ),
      );
      sizePayloads.add({
        'id': id,
        'orgId': orgId,
        'profileId': newId,
        'size': row.size,
        'multiplier': row.multiplier,
        'definition': row.definition,
        'updatedAt': now,
        'deleted': false,
      });
    }
    final complexityRows = <PricingProfileComplexitiesCompanion>[];
    final complexityPayloads = <Map<String, dynamic>>[];
    for (final row in complexities) {
      final id = _uuid.v4();
      complexityRows.add(
        PricingProfileComplexitiesCompanion(
          id: Value(id),
          orgId: Value(orgId),
          profileId: Value(newId),
          level: Value(row.level),
          multiplier: Value(row.multiplier),
          definition: Value(row.definition),
          updatedAt: Value(now),
          deleted: const Value(false),
        ),
      );
      complexityPayloads.add({
        'id': id,
        'orgId': orgId,
        'profileId': newId,
        'level': row.level,
        'multiplier': row.multiplier,
        'definition': row.definition,
        'updatedAt': now,
        'deleted': false,
      });
    }

    await _db.transaction(() async {
      await _db.into(_db.pricingProfiles).insert(profileRow);
      for (final row in serviceTypeRows) {
        await _db.into(_db.pricingProfileServiceTypes).insert(row);
      }
      for (final row in frequencyRows) {
        await _db.into(_db.pricingProfileFrequencies).insert(row);
      }
      for (final row in roomTypeRows) {
        await _db.into(_db.pricingProfileRoomTypes).insert(row);
      }
      for (final row in subItemRows) {
        await _db.into(_db.pricingProfileSubItems).insert(row);
      }
      for (final row in sizeRows) {
        await _db.into(_db.pricingProfileSizes).insert(row);
      }
      for (final row in complexityRows) {
        await _db.into(_db.pricingProfileComplexities).insert(row);
      }
    });
    await _insertOutbox(
      entityType: 'pricing_profile',
      entityId: newId,
      opType: 'create',
      payload: {
        'id': newId,
        'orgId': orgId,
        'name': profileRow.name.value,
        'laborRate': profileRow.laborRate.value,
        'taxEnabled': profileRow.taxEnabled.value,
        'taxRate': profileRow.taxRate.value,
        'ccEnabled': profileRow.ccEnabled.value,
        'ccRate': profileRow.ccRate.value,
        'updatedAt': now,
        'deleted': false,
      },
      orgId: orgId,
      updatedAt: now,
    );
    for (final payload in serviceTypePayloads) {
      await _insertOutbox(
        entityType: 'pricing_profile_service_type',
        entityId: payload['id'] as String,
        opType: 'create',
        payload: payload,
        orgId: orgId,
        updatedAt: now,
      );
    }
    for (final payload in frequencyPayloads) {
      await _insertOutbox(
        entityType: 'pricing_profile_frequency',
        entityId: payload['id'] as String,
        opType: 'create',
        payload: payload,
        orgId: orgId,
        updatedAt: now,
      );
    }
    for (final payload in roomTypePayloads) {
      await _insertOutbox(
        entityType: 'pricing_profile_room_type',
        entityId: payload['id'] as String,
        opType: 'create',
        payload: payload,
        orgId: orgId,
        updatedAt: now,
      );
    }
    for (final payload in subItemPayloads) {
      await _insertOutbox(
        entityType: 'pricing_profile_sub_item',
        entityId: payload['id'] as String,
        opType: 'create',
        payload: payload,
        orgId: orgId,
        updatedAt: now,
      );
    }
    for (final payload in sizePayloads) {
      await _insertOutbox(
        entityType: 'pricing_profile_size',
        entityId: payload['id'] as String,
        opType: 'create',
        payload: payload,
        orgId: orgId,
        updatedAt: now,
      );
    }
    for (final payload in complexityPayloads) {
      await _insertOutbox(
        entityType: 'pricing_profile_complexity',
        entityId: payload['id'] as String,
        opType: 'create',
        payload: payload,
        orgId: orgId,
        updatedAt: now,
      );
    }

    return PricingProfileHeader(
      id: newId,
      orgId: orgId,
      name: profileRow.name.value,
      laborRate: profileRow.laborRate.value,
      taxEnabled: profileRow.taxEnabled.value,
      taxRate: profileRow.taxRate.value,
      ccEnabled: profileRow.ccEnabled.value,
      ccRate: profileRow.ccRate.value,
      updatedAt: now,
      deleted: false,
    );
  }

  Future<void> updateProfileHeader(
    String profileId, {
    String? name,
    double? laborRate,
    bool? taxEnabled,
    double? taxRate,
    bool? ccEnabled,
    double? ccRate,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.pricingProfiles)
          ..where((tbl) => tbl.orgId.equals(orgId) & tbl.id.equals(profileId)))
        .write(
          PricingProfilesCompanion(
            name: name == null ? const Value.absent() : Value(name.trim()),
            laborRate: laborRate == null
                ? const Value.absent()
                : Value(laborRate),
            taxEnabled: taxEnabled == null
                ? const Value.absent()
                : Value(taxEnabled),
            taxRate: taxRate == null ? const Value.absent() : Value(taxRate),
            ccEnabled: ccEnabled == null
                ? const Value.absent()
                : Value(ccEnabled),
            ccRate: ccRate == null ? const Value.absent() : Value(ccRate),
            updatedAt: Value(now),
          ),
        );
    await _insertOutbox(
      entityType: 'pricing_profile',
      entityId: profileId,
      opType: 'update',
      payload: {
        if (name != null) 'name': name.trim(),
        if (laborRate != null) 'laborRate': laborRate,
        if (taxEnabled != null) 'taxEnabled': taxEnabled,
        if (taxRate != null) 'taxRate': taxRate,
        if (ccEnabled != null) 'ccEnabled': ccEnabled,
        if (ccRate != null) 'ccRate': ccRate,
        'updatedAt': now,
        'deleted': false,
        'orgId': orgId,
        'id': profileId,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  Future<void> deleteProfile(String profileId) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.pricingProfiles)
          ..where((tbl) => tbl.orgId.equals(orgId) & tbl.id.equals(profileId)))
        .write(
          PricingProfilesCompanion(
            deleted: const Value(true),
            updatedAt: Value(now),
          ),
        );
    await _insertOutbox(
      entityType: 'pricing_profile',
      entityId: profileId,
      opType: 'delete',
      payload: {
        'deleted': true,
        'updatedAt': now,
        'orgId': orgId,
        'id': profileId,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  PricingProfileHeader _mapHeader(PricingProfileRow row) {
    return PricingProfileHeader(
      id: row.id,
      orgId: row.orgId,
      name: row.name,
      laborRate: row.laborRate,
      taxEnabled: row.taxEnabled,
      taxRate: row.taxRate,
      ccEnabled: row.ccEnabled,
      ccRate: row.ccRate,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  Future<OrgSettings> _loadOrgSettings(String orgId) async {
    final row =
        await (_db.select(_db.orgSettingsTable)
              ..where((tbl) => tbl.orgId.equals(orgId))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      return OrgSettings.defaults;
    }
    return OrgSettings(
      laborRate: row.laborRate,
      taxEnabled: row.taxEnabled,
      taxRate: row.taxRate,
      ccEnabled: row.ccEnabled,
      ccRate: row.ccRate,
      defaultPricingProfileId: row.defaultPricingProfileId,
    );
  }

  Future<void> _insertOutbox({
    required String entityType,
    required String entityId,
    required String opType,
    required Map<String, dynamic> payload,
    required String orgId,
    required int updatedAt,
  }) async {
    final existing =
        await (_db.select(_db.outbox)
              ..where(
                (tbl) =>
                    tbl.orgId.equals(orgId) &
                    tbl.entityType.equals(entityType) &
                    tbl.entityId.equals(entityId) &
                    tbl.status.equals('pending'),
              )
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) {
      await (_db.update(
        _db.outbox,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        OutboxCompanion(
          opType: Value(opType),
          payload: Value(jsonEncode(payload)),
          updatedAt: Value(updatedAt),
          status: const Value('pending'),
        ),
      );
    } else {
      await _db
          .into(_db.outbox)
          .insert(
            OutboxCompanion(
              id: Value(_uuid.v4()),
              entityType: Value(entityType),
              entityId: Value(entityId),
              opType: Value(opType),
              payload: Value(jsonEncode(payload)),
              updatedAt: Value(updatedAt),
              orgId: Value(orgId),
              status: const Value('pending'),
            ),
          );
    }
    unawaited(_syncService.sync());
  }
}

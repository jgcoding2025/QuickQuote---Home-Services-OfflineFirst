import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'local_db.dart';
import 'org_settings_models.dart';
import 'pricing_profile_catalog_seed.dart';
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
    final catalogSeeder = PricingProfileCatalogSeeder(
      db: _db,
      uuid: _uuid,
      insertOutbox: _insertOutbox,
    );
    final seedData = await catalogSeeder.loadSeedData();
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

    await _db.transaction(() async {
      await _db.into(_db.pricingProfiles).insert(profileRow);
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

      await catalogSeeder.insertCatalogRows(
        orgId: orgId,
        profileId: newId,
        updatedAt: now,
        data: seedData,
      );
    });

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

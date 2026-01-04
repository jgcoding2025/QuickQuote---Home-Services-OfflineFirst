import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'local_db.dart';
import 'pricing_profile_models.dart';
import 'session_controller.dart';
import 'sync_service.dart';

class PricingProfileCatalogRepositoryLocalFirst {
  PricingProfileCatalogRepositoryLocalFirst({
    required AppDatabase db,
    required SessionController sessionController,
    required SyncService syncService,
    Uuid? uuid,
  })  : _db = db,
        _sessionController = sessionController,
        _syncService = syncService,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final SessionController _sessionController;
  final SyncService _syncService;
  final Uuid _uuid;

  Stream<PricingProfileCatalog> streamCatalog(String profileId) {
    late final StreamController<PricingProfileCatalog> controller;
    StreamSubscription<AppSession?>? sessionSub;
    StreamSubscription<List<PricingProfileServiceTypeRow>>? serviceTypesSub;
    StreamSubscription<List<PricingProfileFrequencyRow>>? frequenciesSub;
    StreamSubscription<List<PricingProfileRoomTypeRow>>? roomTypesSub;
    StreamSubscription<List<PricingProfileSubItemRow>>? subItemsSub;
    StreamSubscription<List<PricingProfileSizeRow>>? sizesSub;
    StreamSubscription<List<PricingProfileComplexityRow>>? complexitiesSub;
    var emitInProgress = false;
    var emitQueued = false;

    Future<void> emit() async {
      if (emitInProgress) {
        emitQueued = true;
        return;
      }
      emitInProgress = true;
      try {
        final catalog = await loadCatalog(profileId);
        if (!controller.isClosed) {
          controller.add(catalog);
        }
      } finally {
        emitInProgress = false;
        if (emitQueued) {
          emitQueued = false;
          unawaited(emit());
        }
      }
    }

    Future<void> cancelTableSubs() async {
      await serviceTypesSub?.cancel();
      await frequenciesSub?.cancel();
      await roomTypesSub?.cancel();
      await subItemsSub?.cancel();
      await sizesSub?.cancel();
      await complexitiesSub?.cancel();
      serviceTypesSub = null;
      frequenciesSub = null;
      roomTypesSub = null;
      subItemsSub = null;
      sizesSub = null;
      complexitiesSub = null;
    }

    void listenSession(AppSession? session) {
      unawaited(cancelTableSubs());
      if (session == null || session.orgId == null) {
        if (!controller.isClosed) {
          controller.add(PricingProfileCatalog.empty());
        }
        return;
      }
      final orgId = session.orgId!;
      serviceTypesSub = (_db.select(_db.pricingProfileServiceTypes)
            ..where(
              (tbl) =>
                  tbl.orgId.equals(orgId) &
                  tbl.profileId.equals(profileId) &
                  tbl.deleted.equals(false),
            ))
          .watch()
          .listen((_) => emit());
      frequenciesSub = (_db.select(_db.pricingProfileFrequencies)
            ..where(
              (tbl) =>
                  tbl.orgId.equals(orgId) &
                  tbl.profileId.equals(profileId) &
                  tbl.deleted.equals(false),
            ))
          .watch()
          .listen((_) => emit());
      roomTypesSub = (_db.select(_db.pricingProfileRoomTypes)
            ..where(
              (tbl) =>
                  tbl.orgId.equals(orgId) &
                  tbl.profileId.equals(profileId) &
                  tbl.deleted.equals(false),
            ))
          .watch()
          .listen((_) => emit());
      subItemsSub = (_db.select(_db.pricingProfileSubItems)
            ..where(
              (tbl) =>
                  tbl.orgId.equals(orgId) &
                  tbl.profileId.equals(profileId) &
                  tbl.deleted.equals(false),
            ))
          .watch()
          .listen((_) => emit());
      sizesSub = (_db.select(_db.pricingProfileSizes)
            ..where(
              (tbl) =>
                  tbl.orgId.equals(orgId) &
                  tbl.profileId.equals(profileId) &
                  tbl.deleted.equals(false),
            ))
          .watch()
          .listen((_) => emit());
      complexitiesSub = (_db.select(_db.pricingProfileComplexities)
            ..where(
              (tbl) =>
                  tbl.orgId.equals(orgId) &
                  tbl.profileId.equals(profileId) &
                  tbl.deleted.equals(false),
            ))
          .watch()
          .listen((_) => emit());
      unawaited(emit());
    }

    controller = StreamController<PricingProfileCatalog>.broadcast(
      onListen: () {
        listenSession(_sessionController.value);
        sessionSub = _sessionController.stream.listen(listenSession);
      },
      onCancel: () async {
        await cancelTableSubs();
        await sessionSub?.cancel();
        sessionSub = null;
      },
    );

    return controller.stream;
  }

  Future<PricingProfileCatalog> loadCatalog(String profileId) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      return PricingProfileCatalog.empty();
    }
    final serviceTypes = await (_db.select(_db.pricingProfileServiceTypes)
          ..where(
            (tbl) =>
                tbl.orgId.equals(orgId) &
                tbl.profileId.equals(profileId) &
                tbl.deleted.equals(false),
          ))
        .get();
    final frequencies = await (_db.select(_db.pricingProfileFrequencies)
          ..where(
            (tbl) =>
                tbl.orgId.equals(orgId) &
                tbl.profileId.equals(profileId) &
                tbl.deleted.equals(false),
          ))
        .get();
    final roomTypes = await (_db.select(_db.pricingProfileRoomTypes)
          ..where(
            (tbl) =>
                tbl.orgId.equals(orgId) &
                tbl.profileId.equals(profileId) &
                tbl.deleted.equals(false),
          ))
        .get();
    final subItems = await (_db.select(_db.pricingProfileSubItems)
          ..where(
            (tbl) =>
                tbl.orgId.equals(orgId) &
                tbl.profileId.equals(profileId) &
                tbl.deleted.equals(false),
          ))
        .get();
    final sizes = await (_db.select(_db.pricingProfileSizes)
          ..where(
            (tbl) =>
                tbl.orgId.equals(orgId) &
                tbl.profileId.equals(profileId) &
                tbl.deleted.equals(false),
          ))
        .get();
    final complexities = await (_db.select(_db.pricingProfileComplexities)
          ..where(
            (tbl) =>
                tbl.orgId.equals(orgId) &
                tbl.profileId.equals(profileId) &
                tbl.deleted.equals(false),
          ))
        .get();

    return PricingProfileCatalog(
      serviceTypes: serviceTypes.map(_mapServiceType).toList(),
      frequencies: frequencies.map(_mapFrequency).toList(),
      roomTypes: roomTypes.map(_mapRoomType).toList(),
      subItems: subItems.map(_mapSubItem).toList(),
      sizes: sizes.map(_mapSize).toList(),
      complexities: complexities.map(_mapComplexity).toList(),
    );
  }

  Future<void> updateServiceType({
    required String id,
    String? serviceType,
    String? description,
    double? pricePerSqFt,
    double? multiplier,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final row =
        await (_db.select(_db.pricingProfileServiceTypes)
              ..where((tbl) => tbl.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Service type not found.');
    }
    await (_db.update(_db.pricingProfileServiceTypes)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      PricingProfileServiceTypesCompanion(
        serviceType:
            serviceType == null ? const Value.absent() : Value(serviceType),
        description:
            description == null ? const Value.absent() : Value(description),
        pricePerSqFt: pricePerSqFt == null
            ? const Value.absent()
            : Value(pricePerSqFt),
        multiplier:
            multiplier == null ? const Value.absent() : Value(multiplier),
        updatedAt: Value(now),
      ),
    );
    await _insertOutbox(
      entityType: 'pricing_profile_service_type',
      entityId: id,
      opType: 'update',
      payload: {
        'id': id,
        'orgId': orgId,
        'profileId': row.profileId,
        if (serviceType != null) 'serviceType': serviceType,
        if (description != null) 'description': description,
        if (pricePerSqFt != null) 'pricePerSqFt': pricePerSqFt,
        if (multiplier != null) 'multiplier': multiplier,
        'updatedAt': now,
        'deleted': false,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  Future<void> updateFrequency({
    required String id,
    double? multiplier,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final row =
        await (_db.select(_db.pricingProfileFrequencies)
              ..where((tbl) => tbl.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Frequency not found.');
    }
    await (_db.update(_db.pricingProfileFrequencies)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      PricingProfileFrequenciesCompanion(
        multiplier:
            multiplier == null ? const Value.absent() : Value(multiplier),
        updatedAt: Value(now),
      ),
    );
    await _insertOutbox(
      entityType: 'pricing_profile_frequency',
      entityId: id,
      opType: 'update',
      payload: {
        'id': id,
        'orgId': orgId,
        'profileId': row.profileId,
        if (multiplier != null) 'multiplier': multiplier,
        'updatedAt': now,
        'deleted': false,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  Future<void> updateRoomType({
    required String id,
    String? roomType,
    String? description,
    int? minutes,
    int? squareFeet,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final row =
        await (_db.select(_db.pricingProfileRoomTypes)
              ..where((tbl) => tbl.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Room type not found.');
    }
    await (_db.update(_db.pricingProfileRoomTypes)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      PricingProfileRoomTypesCompanion(
        roomType:
            roomType == null ? const Value.absent() : Value(roomType),
        description: description == null
            ? const Value.absent()
            : Value(description),
        minutes: minutes == null ? const Value.absent() : Value(minutes),
        squareFeet:
            squareFeet == null ? const Value.absent() : Value(squareFeet),
        updatedAt: Value(now),
      ),
    );
    await _insertOutbox(
      entityType: 'pricing_profile_room_type',
      entityId: id,
      opType: 'update',
      payload: {
        'id': id,
        'orgId': orgId,
        'profileId': row.profileId,
        if (roomType != null) 'roomType': roomType,
        if (description != null) 'description': description,
        if (minutes != null) 'minutes': minutes,
        if (squareFeet != null) 'squareFeet': squareFeet,
        'updatedAt': now,
        'deleted': false,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  Future<void> updateSubItem({
    required String id,
    String? subItem,
    String? description,
    int? minutes,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final row =
        await (_db.select(_db.pricingProfileSubItems)
              ..where((tbl) => tbl.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Add-on item not found.');
    }
    await (_db.update(_db.pricingProfileSubItems)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      PricingProfileSubItemsCompanion(
        subItem: subItem == null ? const Value.absent() : Value(subItem),
        description: description == null
            ? const Value.absent()
            : Value(description),
        minutes: minutes == null ? const Value.absent() : Value(minutes),
        updatedAt: Value(now),
      ),
    );
    await _insertOutbox(
      entityType: 'pricing_profile_sub_item',
      entityId: id,
      opType: 'update',
      payload: {
        'id': id,
        'orgId': orgId,
        'profileId': row.profileId,
        if (subItem != null) 'subItem': subItem,
        if (description != null) 'description': description,
        if (minutes != null) 'minutes': minutes,
        'updatedAt': now,
        'deleted': false,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  Future<void> updateSize({
    required String id,
    String? size,
    String? definition,
    double? multiplier,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final row =
        await (_db.select(_db.pricingProfileSizes)
              ..where((tbl) => tbl.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Size not found.');
    }
    await (_db.update(_db.pricingProfileSizes)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      PricingProfileSizesCompanion(
        size: size == null ? const Value.absent() : Value(size),
        definition:
            definition == null ? const Value.absent() : Value(definition),
        multiplier: multiplier == null
            ? const Value.absent()
            : Value(multiplier),
        updatedAt: Value(now),
      ),
    );
    await _insertOutbox(
      entityType: 'pricing_profile_size',
      entityId: id,
      opType: 'update',
      payload: {
        'id': id,
        'orgId': orgId,
        'profileId': row.profileId,
        if (size != null) 'size': size,
        if (definition != null) 'definition': definition,
        if (multiplier != null) 'multiplier': multiplier,
        'updatedAt': now,
        'deleted': false,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  Future<void> updateComplexity({
    required String id,
    String? level,
    String? definition,
    double? multiplier,
  }) async {
    final session = _sessionController.session;
    final orgId = session.orgId;
    if (orgId == null) {
      throw StateError('Organization is not set yet.');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final row =
        await (_db.select(_db.pricingProfileComplexities)
              ..where((tbl) => tbl.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Complexity not found.');
    }
    await (_db.update(_db.pricingProfileComplexities)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      PricingProfileComplexitiesCompanion(
        level: level == null ? const Value.absent() : Value(level),
        definition:
            definition == null ? const Value.absent() : Value(definition),
        multiplier: multiplier == null
            ? const Value.absent()
            : Value(multiplier),
        updatedAt: Value(now),
      ),
    );
    await _insertOutbox(
      entityType: 'pricing_profile_complexity',
      entityId: id,
      opType: 'update',
      payload: {
        'id': id,
        'orgId': orgId,
        'profileId': row.profileId,
        if (level != null) 'level': level,
        if (definition != null) 'definition': definition,
        if (multiplier != null) 'multiplier': multiplier,
        'updatedAt': now,
        'deleted': false,
      },
      orgId: orgId,
      updatedAt: now,
    );
  }

  PricingProfileServiceType _mapServiceType(
    PricingProfileServiceTypeRow row,
  ) {
    return PricingProfileServiceType(
      id: row.id,
      orgId: row.orgId,
      profileId: row.profileId,
      row: row.row,
      category: row.category,
      serviceType: row.serviceType,
      description: row.description,
      pricePerSqFt: row.pricePerSqFt,
      multiplier: row.multiplier,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  PricingProfileFrequency _mapFrequency(PricingProfileFrequencyRow row) {
    return PricingProfileFrequency(
      id: row.id,
      orgId: row.orgId,
      profileId: row.profileId,
      serviceType: row.serviceType,
      frequency: row.frequency,
      multiplier: row.multiplier,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  PricingProfileRoomType _mapRoomType(PricingProfileRoomTypeRow row) {
    return PricingProfileRoomType(
      id: row.id,
      orgId: row.orgId,
      profileId: row.profileId,
      row: row.row,
      category: row.category,
      roomType: row.roomType,
      description: row.description,
      minutes: row.minutes,
      squareFeet: row.squareFeet,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  PricingProfileSubItem _mapSubItem(PricingProfileSubItemRow row) {
    return PricingProfileSubItem(
      id: row.id,
      orgId: row.orgId,
      profileId: row.profileId,
      category: row.category,
      subItem: row.subItem,
      description: row.description,
      minutes: row.minutes,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  PricingProfileSize _mapSize(PricingProfileSizeRow row) {
    return PricingProfileSize(
      id: row.id,
      orgId: row.orgId,
      profileId: row.profileId,
      size: row.size,
      multiplier: row.multiplier,
      definition: row.definition,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  PricingProfileComplexity _mapComplexity(PricingProfileComplexityRow row) {
    return PricingProfileComplexity(
      id: row.id,
      orgId: row.orgId,
      profileId: row.profileId,
      level: row.level,
      multiplier: row.multiplier,
      definition: row.definition,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
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
      await (_db.update(_db.outbox)..where((tbl) => tbl.id.equals(existing.id)))
          .write(
        OutboxCompanion(
          opType: Value(opType),
          payload: Value(jsonEncode(payload)),
          updatedAt: Value(updatedAt),
          status: const Value('pending'),
        ),
      );
    } else {
      await _db.into(_db.outbox).insert(
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
    _syncService.requestUpload(reason: 'pricing_catalog_change');
  }
}

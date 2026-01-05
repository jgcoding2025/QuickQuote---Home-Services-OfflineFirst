import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'local_db.g.dart';

@DataClassName('ClientRow')
class Clients extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  TextColumn get firstName => text().withDefault(const Constant(''))();
  TextColumn get lastName => text().withDefault(const Constant(''))();
  TextColumn get street1 => text().withDefault(const Constant(''))();
  TextColumn get street2 => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get state => text().withDefault(const Constant(''))();
  TextColumn get zip => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('QuoteRow')
class Quotes extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  TextColumn get clientId => text().withDefault(const Constant(''))();
  TextColumn get clientName => text().withDefault(const Constant(''))();
  TextColumn get quoteName => text().withDefault(const Constant(''))();
  TextColumn get quoteDate => text().withDefault(const Constant(''))();
  TextColumn get serviceType => text().withDefault(const Constant(''))();
  TextColumn get frequency => text().withDefault(const Constant(''))();
  TextColumn get lastProClean => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('Draft'))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get totalSqFt => text().withDefault(const Constant(''))();
  BoolColumn get useTotalSqFt => boolean().withDefault(const Constant(true))();
  TextColumn get estimatedSqFt => text().withDefault(const Constant(''))();
  BoolColumn get petsPresent => boolean().withDefault(const Constant(false))();
  BoolColumn get homeOccupied => boolean().withDefault(const Constant(true))();
  TextColumn get entryCode => text().withDefault(const Constant(''))();
  TextColumn get paymentMethod => text().withDefault(const Constant(''))();
  BoolColumn get feedbackDiscussed =>
      boolean().withDefault(const Constant(false))();
  RealColumn get laborRate => real().withDefault(const Constant(40.0))();
  BoolColumn get taxEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get ccEnabled => boolean().withDefault(const Constant(false))();
  RealColumn get taxRate => real().withDefault(const Constant(0.07))();
  RealColumn get ccRate => real().withDefault(const Constant(0.03))();
  TextColumn get pricingProfileId =>
      text().withDefault(const Constant('default'))();
  TextColumn get defaultRoomType => text().withDefault(const Constant(''))();
  TextColumn get defaultLevel => text().withDefault(const Constant(''))();
  TextColumn get defaultSize => text().withDefault(const Constant(''))();
  TextColumn get defaultComplexity => text().withDefault(const Constant(''))();
  TextColumn get subItemType => text().withDefault(const Constant(''))();
  TextColumn get specialNotes => text().withDefault(const Constant(''))();
  TextColumn get petsJson => text().withDefault(const Constant('[]'))();
  TextColumn get householdMembersJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('QuoteItemRow')
class QuoteItems extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get quoteId => text()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get payload => text().withDefault(const Constant('{}'))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('OrgSettingsRow')
class OrgSettingsTable extends Table {
  TextColumn get orgId => text()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  RealColumn get laborRate => real().withDefault(const Constant(40.0))();
  BoolColumn get taxEnabled => boolean().withDefault(const Constant(false))();
  RealColumn get taxRate => real().withDefault(const Constant(0.07))();
  BoolColumn get ccEnabled => boolean().withDefault(const Constant(false))();
  RealColumn get ccRate => real().withDefault(const Constant(0.03))();
  TextColumn get defaultPricingProfileId =>
      text().withDefault(const Constant('default'))();

  @override
  Set<Column<Object>>? get primaryKey => {orgId};
}

@DataClassName('PricingProfileRow')
class PricingProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get name => text()();
  RealColumn get laborRate => real().withDefault(const Constant(40.0))();
  BoolColumn get taxEnabled => boolean().withDefault(const Constant(false))();
  RealColumn get taxRate => real().withDefault(const Constant(0.07))();
  BoolColumn get ccEnabled => boolean().withDefault(const Constant(false))();
  RealColumn get ccRate => real().withDefault(const Constant(0.03))();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('PricingProfileServiceTypeRow')
class PricingProfileServiceTypes extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get profileId => text()();
  IntColumn get row => integer().withDefault(const Constant(0))();
  TextColumn get category => text().withDefault(const Constant('General'))();
  TextColumn get serviceType => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get pricePerSqFt => real().withDefault(const Constant(0))();
  RealColumn get multiplier => real().withDefault(const Constant(1))();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('PricingProfileFrequencyRow')
class PricingProfileFrequencies extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get profileId => text()();
  TextColumn get serviceType => text()();
  TextColumn get frequency => text()();
  RealColumn get multiplier => real().withDefault(const Constant(1))();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('PricingProfileRoomTypeRow')
class PricingProfileRoomTypes extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get profileId => text()();
  IntColumn get row => integer().withDefault(const Constant(0))();
  TextColumn get category => text().withDefault(const Constant('General'))();
  TextColumn get roomType => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  IntColumn get squareFeet => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('PricingProfileSubItemRow')
class PricingProfileSubItems extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get profileId => text()();
  TextColumn get category => text().withDefault(const Constant('General'))();
  TextColumn get subItem => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('PricingProfileSizeRow')
class PricingProfileSizes extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get profileId => text()();
  TextColumn get size => text()();
  RealColumn get multiplier => real().withDefault(const Constant(1))();
  TextColumn get definition => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('PricingProfileComplexityRow')
class PricingProfileComplexities extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get profileId => text()();
  TextColumn get level => text()();
  RealColumn get multiplier => real().withDefault(const Constant(1))();
  TextColumn get definition => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('OutboxRow')
class Outbox extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get opType => text()();
  TextColumn get payload => text()();
  IntColumn get updatedAt => integer()();
  TextColumn get orgId => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('SyncStateRow')
class SyncState extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  IntColumn get lastSyncAt => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>>? get primaryKey => {id, orgId};
}

@DataClassName('FinalizedDocumentRow')
class FinalizedDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get quoteId => text()();
  TextColumn get docType => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get status => text()();
  TextColumn get localPath => text()();
  TextColumn get remotePath => text().nullable()();
  TextColumn get quoteSnapshot => text()();
  TextColumn get pricingSnapshot => text()();
  TextColumn get totalsSnapshot => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Clients,
    Quotes,
    QuoteItems,
    OrgSettingsTable,
    PricingProfiles,
    PricingProfileServiceTypes,
    PricingProfileFrequencies,
    PricingProfileRoomTypes,
    PricingProfileSubItems,
    PricingProfileSizes,
    PricingProfileComplexities,
    Outbox,
    SyncState,
    FinalizedDocuments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(
              quotes,
              quotes.pricingProfileId,
            );
            await m.addColumn(
              orgSettingsTable,
              orgSettingsTable.defaultPricingProfileId,
            );
            await m.createTable(pricingProfiles);
            await m.createTable(pricingProfileServiceTypes);
            await m.createTable(pricingProfileFrequencies);
            await m.createTable(pricingProfileRoomTypes);
            await m.createTable(pricingProfileSubItems);
            await m.createTable(pricingProfileSizes);
            await m.createTable(pricingProfileComplexities);
          }
          if (from < 3) {
            await m.createTable(finalizedDocuments);
          }
          if (from < 4) {
            await m.addColumn(quotes, quotes.petsJson);
            await m.addColumn(quotes, quotes.householdMembersJson);
          }
        },
      );

  Stream<List<ClientRow>> watchClients(String orgId) {
    return (select(clients)
          ..where((tbl) => tbl.orgId.equals(orgId) & tbl.deleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.lastName)]))
        .watch();
  }

  Stream<ClientRow?> watchClientById(String orgId, String clientId) {
    return (select(clients)
          ..where(
            (tbl) =>
                tbl.orgId.equals(orgId) &
                tbl.id.equals(clientId) &
                tbl.deleted.equals(false),
          )
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<QuoteRow>> watchQuotes(String orgId) {
    return (select(quotes)
          ..where((tbl) => tbl.orgId.equals(orgId) & tbl.deleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .watch();
  }

  Stream<QuoteRow?> watchQuoteById(String orgId, String quoteId) {
    return (select(quotes)
          ..where(
            (tbl) =>
                tbl.orgId.equals(orgId) &
                tbl.id.equals(quoteId) &
                tbl.deleted.equals(false),
          )
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<QuoteRow>> watchQuotesForClient(String orgId, String clientId) {
    return (select(quotes)
          ..where(
            (tbl) =>
                tbl.orgId.equals(orgId) &
                tbl.deleted.equals(false) &
                tbl.clientId.equals(clientId),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .watch();
  }

  Future<List<QuoteItemRow>> loadQuoteItems(String quoteId) {
    return (select(
      quoteItems,
    )..where((tbl) => tbl.quoteId.equals(quoteId))).get();
  }

  Stream<OrgSettingsRow?> watchOrgSettings(String orgId) {
    return (select(orgSettingsTable)
          ..where((tbl) => tbl.orgId.equals(orgId))
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<int> upsertClient(ClientsCompanion entry) {
    return into(clients).insertOnConflictUpdate(entry);
  }

  Future<int> upsertQuote(QuotesCompanion entry) {
    return into(quotes).insertOnConflictUpdate(entry);
  }

  Future<int> upsertOrgSettings(OrgSettingsTableCompanion entry) {
    return into(orgSettingsTable).insertOnConflictUpdate(entry);
  }

  Future<void> replaceQuoteItems(
    String quoteId,
    List<QuoteItemRow> items,
  ) async {
    await (delete(
      quoteItems,
    )..where((tbl) => tbl.quoteId.equals(quoteId))).go();
    if (items.isEmpty) {
      return;
    }
    await batch((batch) {
      batch.insertAll(quoteItems, items);
    });
  }

  Future<void> setSyncState(String entityType, String orgId, int lastSyncAt) {
    return into(syncState).insertOnConflictUpdate(
      SyncStateCompanion.insert(
        id: entityType,
        orgId: orgId,
        lastSyncAt: Value(lastSyncAt),
      ),
    );
  }

  Future<int> getLastSync(String entityType, String orgId) async {
    final row =
        await (select(syncState)
              ..where(
                (tbl) => tbl.id.equals(entityType) & tbl.orgId.equals(orgId),
              )
              ..limit(1))
            .getSingleOrNull();
    return row?.lastSyncAt ?? 0;
  }

  Future<void> migrateOrg(String fromOrgId, String toOrgId) async {
    await (update(clients)..where((tbl) => tbl.orgId.equals(fromOrgId))).write(
      ClientsCompanion(orgId: Value(toOrgId)),
    );
    await (update(quotes)..where((tbl) => tbl.orgId.equals(fromOrgId))).write(
      QuotesCompanion(orgId: Value(toOrgId)),
    );
    await (update(quoteItems)..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(QuoteItemsCompanion(orgId: Value(toOrgId)));
    await (update(orgSettingsTable)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(OrgSettingsTableCompanion(orgId: Value(toOrgId)));
    await (update(pricingProfiles)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(PricingProfilesCompanion(orgId: Value(toOrgId)));
    await (update(pricingProfileServiceTypes)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(PricingProfileServiceTypesCompanion(orgId: Value(toOrgId)));
    await (update(pricingProfileFrequencies)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(PricingProfileFrequenciesCompanion(orgId: Value(toOrgId)));
    await (update(pricingProfileRoomTypes)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(PricingProfileRoomTypesCompanion(orgId: Value(toOrgId)));
    await (update(pricingProfileSubItems)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(PricingProfileSubItemsCompanion(orgId: Value(toOrgId)));
    await (update(pricingProfileSizes)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(PricingProfileSizesCompanion(orgId: Value(toOrgId)));
    await (update(pricingProfileComplexities)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(PricingProfileComplexitiesCompanion(orgId: Value(toOrgId)));
    await (update(outbox)..where((tbl) => tbl.orgId.equals(fromOrgId))).write(
      OutboxCompanion(orgId: Value(toOrgId)),
    );
    await (update(syncState)..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(SyncStateCompanion(orgId: Value(toOrgId)));
    await (update(finalizedDocuments)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(FinalizedDocumentsCompanion(orgId: Value(toOrgId)));
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/quickquote.sqlite');
      return NativeDatabase(file);
    });
  }
}

QuoteItemRow quoteItemFromMap({
  required String id,
  required String orgId,
  required String quoteId,
  required int updatedAt,
  required int sortOrder,
  required Map<String, dynamic> payload,
}) {
  return QuoteItemRow(
    id: id,
    orgId: orgId,
    quoteId: quoteId,
    updatedAt: updatedAt,
    deleted: false,
    sortOrder: sortOrder,
    payload: jsonEncode(payload),
  );
}

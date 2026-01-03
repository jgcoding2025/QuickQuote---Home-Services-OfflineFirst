import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
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
  BoolColumn get feedbackDiscussed => boolean().withDefault(const Constant(false))();
  RealColumn get laborRate => real().withDefault(const Constant(40.0))();
  BoolColumn get taxEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get ccEnabled => boolean().withDefault(const Constant(false))();
  RealColumn get taxRate => real().withDefault(const Constant(0.07))();
  RealColumn get ccRate => real().withDefault(const Constant(0.03))();
  TextColumn get defaultRoomType => text().withDefault(const Constant(''))();
  TextColumn get defaultLevel => text().withDefault(const Constant(''))();
  TextColumn get defaultSize => text().withDefault(const Constant(''))();
  TextColumn get defaultComplexity => text().withDefault(const Constant(''))();
  TextColumn get subItemType => text().withDefault(const Constant(''))();
  TextColumn get specialNotes => text().withDefault(const Constant(''))();

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

  @override
  Set<Column<Object>>? get primaryKey => {orgId};
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

@DriftDatabase(
  tables: [Clients, Quotes, QuoteItems, OrgSettingsTable, Outbox, SyncState],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<ClientRow>> watchClients(String orgId) {
    return (select(clients)
          ..where((tbl) => tbl.orgId.equals(orgId) & tbl.deleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.lastName)]))
        .watch();
  }

  Stream<List<QuoteRow>> watchQuotes(String orgId) {
    return (select(quotes)
          ..where((tbl) => tbl.orgId.equals(orgId) & tbl.deleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .watch();
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
    return (select(quoteItems)
          ..where((tbl) => tbl.quoteId.equals(quoteId)))
        .get();
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

  Future<void> replaceQuoteItems(String quoteId, List<QuoteItemRow> items) async {
    await (delete(quoteItems)..where((tbl) => tbl.quoteId.equals(quoteId))).go();
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
    final row = await (select(syncState)
          ..where((tbl) => tbl.id.equals(entityType) & tbl.orgId.equals(orgId))
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
    await (update(quoteItems)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(QuoteItemsCompanion(orgId: Value(toOrgId)));
    await (update(orgSettingsTable)
          ..where((tbl) => tbl.orgId.equals(fromOrgId)))
        .write(OrgSettingsTableCompanion(orgId: Value(toOrgId)));
    await (update(outbox)..where((tbl) => tbl.orgId.equals(fromOrgId))).write(
      OutboxCompanion(orgId: Value(toOrgId)),
    );
    await (update(syncState)..where((tbl) => tbl.orgId.equals(fromOrgId))).write(
      SyncStateCompanion(orgId: Value(toOrgId)),
    );
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

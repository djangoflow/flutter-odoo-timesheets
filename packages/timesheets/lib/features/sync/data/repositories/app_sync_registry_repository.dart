import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:drift/drift.dart';

import '../database/database.dart';

class AppSyncRegistryRepository extends SyncRegistryRepository {
  final AppDatabase database;

  AppSyncRegistryRepository(this.database);

  @override
  Future<void> upsertRegistry({
    required String modelName,
    required int modelRecordId,
    required String backendId,
    required DateTime recordWriteDate,
    DateTime? recordDeletedAt,
    bool pendingSync = true,
  }) async {
    // Check if the registry exists
    final existingRegistry = await (database.select(database.syncRegistries)
          ..where((tbl) =>
              tbl.modelName.equals(modelName) &
              tbl.modelRecordId.equals(modelRecordId) &
              tbl.backendId.equals(backendId)))
        .getSingleOrNull();

    if (existingRegistry != null) {
      // Update existing registry
      await (database.update(database.syncRegistries)
            ..where((tbl) =>
                tbl.modelName.equals(modelName) &
                tbl.modelRecordId.equals(modelRecordId) &
                tbl.backendId.equals(backendId)))
          .write(
        SyncRegistriesCompanion(
          recordWriteDate: Value(recordWriteDate),
          recordDeletedAt: Value(recordDeletedAt),
          updatedAt: Value(DateTime.timestamp()),
          pendingSync: Value(pendingSync),
        ),
      );
    } else {
      // Insert new registry
      await database.into(database.syncRegistries).insert(
            SyncRegistriesCompanion.insert(
              modelName: modelName,
              modelRecordId: modelRecordId,
              backendId: backendId,
              recordWriteDate: recordWriteDate,
              recordDeletedAt: Value(recordDeletedAt),
              updatedAt: DateTime.timestamp(),
              createdAt: DateTime.timestamp(),
              pendingSync: Value(pendingSync),
            ),
          );
    }
  }

  @override
  Future<void> batchUpsertRegistry(
      List<SyncRegistriesCompanion> syncRegistries) async {
    await database.transaction(() async {
      for (final registry in syncRegistries) {
        await upsertRegistry(
          modelName: registry.modelName.value,
          modelRecordId: registry.modelRecordId.value,
          backendId: registry.backendId.value,
          recordWriteDate: registry.recordWriteDate.value,
          recordDeletedAt: registry.recordDeletedAt.value,
          pendingSync: registry.pendingSync.value,
        );
      }
    });
  }

  @override
  Future<List<SyncRegistry>> getPendingSyncRecords(
          String backendId, String modelName) =>
      (database.select(database.syncRegistries)
            ..where((tbl) =>
                tbl.backendId.equals(backendId) &
                tbl.modelName.equals(modelName) &
                tbl.pendingSync.equals(true)))
          .get();

  @override
  Future<void> markSyncComplete(int syncRegistryId) =>
      (database.update(database.syncRegistries)
            ..where((tbl) => tbl.id.equals(syncRegistryId)))
          .write(const SyncRegistriesCompanion(pendingSync: Value(false)));

  @override
  Future<String> registerBackend(String id, String type) async {
    await database.into(database.syncBackends).insertOnConflictUpdate(
          SyncBackendsCompanion(
            id: Value(id),
            type: Value(type),
          ),
        );
    return id;
  }

  @override
  Future<DateTime?> getLastSyncTime(String backendId, String modelName) async {
    final query = database.select(database.syncRegistries)
      ..where((tbl) =>
          tbl.backendId.equals(backendId) & tbl.modelName.equals(modelName))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(1);

    final result = await query.getSingleOrNull();
    return result?.updatedAt;
  }

  @override
  Future<void> deleteRegistry({
    required String modelName,
    required int modelRecordId,
  }) async {
    await (database.delete(database.syncRegistries)
          ..where((tbl) =>
              tbl.modelName.equals(modelName) &
              tbl.modelRecordId.equals(modelRecordId)))
        .go();
  }

  @override
  Future<List<SyncRegistry>> getAllRegistries(String modelName) =>
      (database.select(database.syncRegistries)
            ..where((tbl) => tbl.modelName.equals(modelName)))
          .get();
}

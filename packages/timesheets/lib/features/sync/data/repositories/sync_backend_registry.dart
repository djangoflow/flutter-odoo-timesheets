import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:drift/drift.dart';
import 'package:timesheets/features/sync/sync.dart';

class SyncBackendsRepository {
  final AppDatabase _db;

  SyncBackendsRepository(this._db);

  // Insert a new SyncBackend entry
  Future<void> insertSyncBackend(SyncBackend syncBackend) async {
    await _db.into(_db.syncBackends).insert(syncBackend);
  }

  // Update an existing SyncBackend entry
  Future<void> updateSyncBackend(SyncBackend syncBackend) async {
    await _db.update(_db.syncBackends).replace(syncBackend);
  }

  // Fetch all SyncBackends for a specific baseUrl
  Future<List<SyncBackend>> fetchBackendsByBaseUrl(String baseUrl) async =>
      await (_db.select(_db.syncBackends)
            ..where((tbl) => tbl.baseUrl.equals(baseUrl)))
          .get();

  // Delete a SyncBackend entry
  Future<void> deleteSyncBackend(String id, String baseUrl) async {
    await (_db.delete(_db.syncBackends)
          ..where((tbl) => tbl.id.equals(id) & tbl.baseUrl.equals(baseUrl)))
        .go();
  }
}

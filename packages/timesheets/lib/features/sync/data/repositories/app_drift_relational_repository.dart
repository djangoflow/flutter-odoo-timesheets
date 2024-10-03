import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';

import 'app_drift_odoo_sync_repository.dart';

abstract class AppDriftRelationalRepository<T extends SyncModel,
    TTable extends BaseTable> extends AppDriftOdooSyncRepository<T, TTable> {
  final Map<String, DriftOdooSyncRepository> relatedRepositories;

  AppDriftRelationalRepository(
    super.primaryBackend,
    super.secondaryBackend,
    super.syncStrategy,
    this.relatedRepositories,
  );

  @override
  Future<void> sync() async {
    for (final repository in relatedRepositories.values) {
      await repository.sync();
    }

    await super.sync();
  }
}

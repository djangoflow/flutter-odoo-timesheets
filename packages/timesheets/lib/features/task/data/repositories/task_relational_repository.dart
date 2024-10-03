import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/task/data/models/task_model.dart';

import '../backends/task_relational_drift_backend.dart';
import '../backends/task_relational_odoo_backend.dart';

class TaskRelationalRepository
    extends AppDriftRelationalRepository<TaskModel, ProjectTasks> {
  TaskRelationalRepository(
    TaskRelationalOdooBackend super.primaryBackend,
    TaskRelationalDriftBackend super.secondaryBackend,
    super.syncStrategy,
    super.relatedRepositories,
  );

  @override
  String get modelName => TaskModel.odooModelName;

  @override
  Future<List<TaskModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? projectId,
    String? search,
    int? limit,
    int? offset,
    bool returnOnlySecondary = false,
  }) async {
    final driftBackend = secondaryBackend as TaskRelationalDriftBackend;
    final secondaryBackendFetch = driftBackend.getAll(
      ids: ids,
      since: since,
      projectId: projectId,
      search: search,
      limit: limit,
      offset: offset,
    );
    if (await isPrimaryBackendAvailable && returnOnlySecondary == false) {
      try {
        final items =
            await (primaryBackend as TaskRelationalOdooBackend).getAll(
          ids: ids,
          since: since,
          projectId: projectId,
          search: search,
          limit: limit,
          offset: offset,
        );
        await updateSecondaryBackend(items);
        await (syncStrategy as DriftOdooSyncStrategy<TaskModel, ProjectTasks>)
            .syncBatch(items, primaryBackend, modelName: modelName);
        if (!returnOnlySecondary) {
          return items;
        }
      } catch (e, stackTrace) {
        logger.e('Failed to fetch from primary backend:', e, stackTrace);
        return secondaryBackendFetch;
      }
    }
    return secondaryBackendFetch;
  }
}

// lib/features/analytic_lines/repositories/analytic_line_repository.dart
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetRepository
    extends AppDriftOdooSyncRepository<TimesheetModel, AnalyticLines> {
  TimesheetRepository(
    super.primaryBackend,
    super.secondaryBackend,
    TimesheetDriftOdooSyncStrategy super.syncStrategy,
  );

  @override
  String get modelName => TimesheetModel.odooModelName;

  @override
  Future<List<TimesheetModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? projectId,
    int? taskId,
    int? limit,
    int? offset,
    bool returnOnlySecondary = false,
    bool? activeOnly,
    bool? favoriteOnly,
  }) async {
    final driftBackend = secondaryBackend as TimesheetDriftBackend;
    final driftBackendFetch = driftBackend.getAll(
      ids: ids,
      since: since,
      projectId: projectId,
      taskId: taskId,
      limit: limit,
      offset: offset,
      activeOnly: activeOnly,
      favoriteOnly: favoriteOnly,
    );
    if (await isPrimaryBackendAvailable && returnOnlySecondary == false) {
      try {
        final items = await (primaryBackend as TimesheetOdooBackend).getAll(
          ids: ids,
          since: since,
          projectId: projectId,
          taskId: taskId,
          limit: limit,
          offset: offset,
        );
        await updateSecondaryBackend(items);
        await (syncStrategy as TimesheetDriftOdooSyncStrategy)
            .syncBatch(items, primaryBackend, modelName: modelName);
        if (!returnOnlySecondary) {
          return items;
        }
      } catch (e, stackTrace) {
        logger.e(
          'Failed to fetch from primary backend:',
          error: e,
          stackTrace: stackTrace,
        );
        return driftBackendFetch;
      }
    }
    return driftBackendFetch;
  }
}

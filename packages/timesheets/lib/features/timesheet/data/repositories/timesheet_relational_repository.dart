import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetRelationalRepository
    extends AppDriftRelationalRepository<TimesheetModel, AnalyticLines> {
  TimesheetRelationalRepository(
    TimesheetRelationalOdooBackend super.primaryBackend,
    TimesheetRelationalDriftBackend super.secondaryBackend,
    TimesheetDriftOdooSyncStrategy super.syncStrategy,
    super.relatedRepositories,
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
    final driftBackend = secondaryBackend as TimesheetRelationalDriftBackend;
    final secondaryBackendFetch = driftBackend.getAll(
      ids: ids,
      since: since,
      projectId: projectId,
      limit: limit,
      offset: offset,
      taskId: taskId,
      activeOnly: activeOnly,
      favoriteOnly: favoriteOnly,
    );
    if (await isPrimaryBackendAvailable && returnOnlySecondary == false) {
      try {
        final items =
            await (primaryBackend as TimesheetRelationalOdooBackend).getAll(
          ids: ids,
          since: since,
          projectId: projectId,
          limit: limit,
          offset: offset,
          taskId: taskId,
        );
        await updateSecondaryBackend(items);
        await (syncStrategy as TimesheetDriftOdooSyncStrategy)
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

  @override
  Future<TimesheetModel> create(TimesheetModel item) async {
    final driftOdooSyncStrategy =
        (syncStrategy as TimesheetDriftOdooSyncStrategy);
    if (await isPrimaryBackendAvailable) {
      try {
        final createdItem = await primaryBackend.create(item);
        final updatedModel = await secondaryBackend.create(createdItem.copyWith(
          currentStatus: item.currentStatus,
          isFavorite: item.isFavorite,
          lastTicked: item.lastTicked,
        ));
        await driftOdooSyncStrategy
            .syncBatch([updatedModel], primaryBackend, modelName: modelName);
        await driftOdooSyncStrategy
            .syncBatch([updatedModel], secondaryBackend, modelName: modelName);
        return updatedModel;
      } catch (e, stackTrace) {
        logger.e('Error creating item in primary backend:', e, stackTrace);
        return driftOdooSyncStrategy.createWithTemporaryId(
          item,
          secondaryBackend as TimesheetRelationalDriftBackend,
          modelName,
        );
      }
    } else {
      return driftOdooSyncStrategy.createWithTemporaryId(
        item,
        secondaryBackend as TimesheetRelationalDriftBackend,
        modelName,
      );
    }
  }
}

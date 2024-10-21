import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/sync/sync.dart';

class ProjectRepository
    extends AppDriftOdooSyncRepository<ProjectModel, ProjectProjects> {
  ProjectRepository(
    super.primaryBackend,
    super.secondaryBackend,
    super.syncStrategy,
  );

  @override
  String get modelName => ProjectModel.odooModelName;

  @override
  Future<List<ProjectModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? limit,
    int? offset,
    bool? isFavorite,
    String? search,
    bool returnOnlySecondary = true,
    bool? showMarkedAsDeleted,
  }) async {
    final secondaryBackend = super.secondaryBackend as ProjectDriftBackend;
    secondaryFetchCall() => secondaryBackend.getAll(
          ids: ids,
          since: since,
          limit: limit,
          offset: offset,
          isFavorite: isFavorite,
          search: search,
          showMarkedAsDeleted: showMarkedAsDeleted,
        );
    if (await isPrimaryBackendAvailable && returnOnlySecondary == false) {
      try {
        final items = await (primaryBackend as ProjectOdooBackend).getAll(
          ids: ids,
          since: since,
          limit: limit,
          offset: offset,
          isFavorite: isFavorite,
          search: search,
        );

        if (items.isNotEmpty) {
          logger.d(items.first.toJson());
        }
        await updateSecondaryBackend(items);
        await (syncStrategy
                as DriftOdooSyncStrategy<ProjectModel, ProjectProjects>)
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
        return secondaryFetchCall();
      }
    }
    return secondaryFetchCall();
  }
}

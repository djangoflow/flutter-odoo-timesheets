import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:timesheets/features/sync/sync.dart';
import '../models/project_model.dart';

class ProjectRepository
    extends DriftOdooSyncRepository<ProjectModel, ProjectProjects> {
  ProjectRepository(
    super.primaryBackend,
    super.secondaryBackend,
    super.syncStrategy,
  );

  @override
  String get modelName => ProjectModel.odooModelName;
}

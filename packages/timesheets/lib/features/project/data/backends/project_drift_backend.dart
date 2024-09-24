// lib/features/projects/data/backends/project_drift_backend.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:drift/drift.dart';
import 'package:timesheets/features/sync/sync.dart';

import '../models/project_model.dart';

class ProjectDriftBackend
    extends DriftBackend<ProjectModel, ProjectProjects, ProjectProject> {
  ProjectDriftBackend(AppDatabase database, String backendId)
      : super(database, database.projectProjects, backendId);

  @override
  UpdateCompanion<ProjectProject> createCompanionWithBackendId(
      ProjectModel item) {
    final companion = item.toCompanion() as ProjectProjectsCompanion;
    return companion.copyWith(backendId: Value(backendId));
  }

  @override
  ProjectModel fromJson(Map<String, dynamic> json) =>
      ProjectModel.fromJson(json);

  @override
  ProjectModel convertToModel(ProjectProject driftModel) => ProjectModel(
        id: driftModel.id,
        active: driftModel.active,
        isFavorite: driftModel.isFavorite,
        color: driftModel.color,
        name: driftModel.name,
        taskCount: driftModel.taskCount,
        createDate: driftModel.createDate,
        writeDate: driftModel.writeDate,
        isMarkedAsDeleted: driftModel.isMarkedAsDeleted,
      );
}

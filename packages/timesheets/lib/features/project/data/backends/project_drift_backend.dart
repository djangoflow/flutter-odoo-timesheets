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

  @override
  Future<List<ProjectModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? limit,
    int? offset,
    bool? isFavorite,
    String? search,
    bool? showMarkedAsDeleted,
  }) async {
    final database = super.database as AppDatabase;
    final query = database.select(database.projectProjects)
      ..where((tbl) => tbl.backendId.equals(backendId));
    if (ids != null && ids.isNotEmpty) {
      query.where((tbl) => tbl.id.isIn(ids));
    }
    if (since != null) {
      query.where((tbl) => tbl.writeDate.isBiggerThanValue(since));
    }
    if (limit != null) {
      query.limit(limit, offset: offset);
    }
    if (isFavorite != null) {
      query.where((tbl) => tbl.isFavorite.equals(isFavorite));
    }
    if (search != null) {
      query.where((tbl) => tbl.name.like('%$search%'));
    }

    if (showMarkedAsDeleted == false) {
      query.where((tbl) => tbl.isMarkedAsDeleted.equals(false));
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.writeDate, mode: OrderingMode.desc)
    ]);

    final results = await query.get();
    return results.map((row) => convertToModel(row)).toList();
  }
}

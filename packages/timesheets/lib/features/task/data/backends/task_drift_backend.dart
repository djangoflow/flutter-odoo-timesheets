// lib/features/tasks/data/backends/task_drift_backend.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:drift/drift.dart';
import 'package:timesheets/features/sync/sync.dart';

import '../models/task_model.dart';

class TaskDriftBackend
    extends DriftBackend<TaskModel, ProjectTasks, ProjectTask> {
  TaskDriftBackend(AppDatabase database, String backendId)
      : super(database, database.projectTasks, backendId);

  @override
  UpdateCompanion<ProjectTask> createCompanionWithBackendId(TaskModel item) {
    final companion = item.toCompanion() as ProjectTasksCompanion;
    return companion.copyWith(backendId: Value(backendId));
  }

  @override
  TaskModel fromJson(Map<String, dynamic> json) => TaskModel.fromJson(json);

  @override
  TaskModel convertToModel(ProjectTask driftModel) => TaskModel(
        id: driftModel.id,
        active: driftModel.active,
        color: driftModel.color,
        dateDeadline: driftModel.dateDeadline,
        dateEnd: driftModel.dateEnd,
        description: driftModel.description,
        name: driftModel.name,
        priority: driftModel.priority,
        projectId: driftModel.projectId,
        createDate: driftModel.createDate,
        writeDate: driftModel.writeDate,
        isMarkedAsDeleted: driftModel.isMarkedAsDeleted,
      );

  @override
  Future<List<TaskModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? projectId,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final query = database.select(table)
      ..where((tbl) => tbl.backendId.equals(backendId));

    if (ids != null && ids.isNotEmpty) {
      query.where((tbl) => tbl.id.isIn(ids));
    }
    if (since != null) {
      query.where((tbl) => tbl.writeDate.isBiggerThanValue(since));
    }
    if (projectId != null) {
      query.where((tbl) => tbl.projectId.equals(projectId));
    }

    if (search != null && search.isNotEmpty) {
      query.where((tbl) => tbl.name.like('%$search%'));
    }

    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.writeDate, mode: OrderingMode.desc)
    ]);

    final results = await query.get();
    return results.map((row) => convertToModel(row)).toList();
  }
}

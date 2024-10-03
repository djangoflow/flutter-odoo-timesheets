import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:drift/drift.dart';

import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/task/data/backends/task_drift_backend.dart';
import 'package:timesheets/features/task/data/models/task_model.dart';
import 'package:timesheets/utils/utils.dart';

class TaskRelationalDriftBackend extends TaskDriftBackend
    with DriftRelationalFetchMixin<TaskModel, ProjectTasks, ProjectTask> {
  TaskRelationalDriftBackend(super.database, super.backendId);

  @override
  List<Join<HasResultSet, dynamic>> getJoins() {
    final database = super.database as AppDatabase;
    return [
      innerJoin(
        database.projectProjects,
        database.projectProjects.id.equalsExp(database.projectTasks.projectId) &
            database.projectProjects.backendId
                .equalsExp(database.projectTasks.backendId),
      ),
    ];
  }

  @override
  TaskModel mapRowToModel(TypedResult row) {
    final taskData =
        row.readTable((database as AppDatabase).projectTasks).toDomainModel();
    final projectData = row
        .readTable((database as AppDatabase).projectProjects)
        .toDomainModel();

    return taskData.copyWith(
      project: projectData,
    );
  }

  @override
  Future<List<TaskModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? projectId,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final query = createJoinQuery();
    query.where((table as $ProjectTasksTable).backendId.equals(backendId));

    if (ids != null && ids.isNotEmpty) {
      query.where((table as $ProjectTasksTable).id.isIn(ids));
    }
    if (since != null) {
      query.where(
          (table as $ProjectTasksTable).writeDate.isBiggerThanValue(since));
    }
    if (projectId != null) {
      query.where((table as $ProjectTasksTable).projectId.equals(projectId));
    }
    if (search != null && search.isNotEmpty) {
      query.where((table as $ProjectTasksTable).name.like('%$search%'));
    }

    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    final result = await query.get();

    return result.map(mapRowToModel).toList();
  }

  @override
  Future<TaskModel?> getById(int id) async {
    final query = createJoinQuery()
      ..where((table as $ProjectTasksTable).id.equals(id) &
          (table as $ProjectTasksTable).backendId.equals(backendId));

    final result = await query.getSingleOrNull();
    return result != null ? mapRowToModel(result) : null;
  }
}

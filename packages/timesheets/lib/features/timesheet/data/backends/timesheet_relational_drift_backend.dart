import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:drift/drift.dart';

import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetRelationalDriftBackend extends TimesheetDriftBackend
    with
        DriftRelationalFetchMixin<TimesheetModel, AnalyticLines, AnalyticLine> {
  TimesheetRelationalDriftBackend(super.database, super.backendId);

  @override
  List<Join<HasResultSet, dynamic>> getJoins() {
    final database = super.database as AppDatabase;
    return [
      innerJoin(
        database.projectProjects,
        database.projectProjects.id
                .equalsExp(database.analyticLines.projectId) &
            database.projectProjects.backendId
                .equalsExp(database.analyticLines.backendId),
      ),
      innerJoin(
        database.projectTasks,
        database.projectTasks.id.equalsExp(database.analyticLines.taskId) &
            database.projectTasks.backendId
                .equalsExp(database.analyticLines.backendId),
      ),
    ];
  }

  @override
  TimesheetModel mapRowToModel(TypedResult row) {
    final analyticLineData =
        row.readTable((database as AppDatabase).analyticLines).toDomainModel();
    final projectData = row
        .readTable((database as AppDatabase).projectProjects)
        .toDomainModel();
    final taskData =
        row.readTable((database as AppDatabase).projectTasks).toDomainModel();

    return analyticLineData.copyWith(
      project: projectData,
      task: taskData,
    );
  }

  @override
  Future<List<TimesheetModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? projectId,
    int? taskId,
    int? limit,
    int? offset,
    bool? activeOnly,
    bool? favoriteOnly,
  }) async {
    final query = createJoinQuery();
    query.where((table as $AnalyticLinesTable).backendId.equals(backendId));
    // final projectsTable = (database as AppDatabase).projectProjects;
    // final tasksTable = (database as AppDatabase).projectTasks;

    // query.where(projectsTable.backendId.equals(backendId));
    // query.where(tasksTable.backendId.equals(backendId));
    if (ids != null && ids.isNotEmpty) {
      query.where((table as $AnalyticLinesTable).id.isIn(ids));
    }
    if (since != null) {
      query.where(
          (table as $AnalyticLinesTable).writeDate.isBiggerThanValue(since));
    }
    if (projectId != null) {
      query.where((table as $AnalyticLinesTable).projectId.equals(projectId));
    }
    if (taskId != null) {
      query.where((table as $AnalyticLinesTable).taskId.equals(taskId));
    }

    if (activeOnly != null) {
      if (activeOnly) {
        query.where((table as $AnalyticLinesTable).currentStatus.isIn([
          TimerStatus.running.index,
          TimerStatus.paused.index,
          TimerStatus.pausedByForce.index,
        ]));
      } else {
        query.where((table as $AnalyticLinesTable).currentStatus.isNotIn([
          TimerStatus.running.index,
          TimerStatus.paused.index,
          TimerStatus.pausedByForce.index,
        ]));
      }
    }

    if (favoriteOnly != null) {
      query.where(
          (table as $AnalyticLinesTable).isFavorite.equals(favoriteOnly));
    }

    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    query.orderBy([
      OrderingTerm(
          expression: (table as $AnalyticLinesTable).writeDate,
          mode: OrderingMode.desc)
    ]);

    final results = await query.get();
    return results.map(mapRowToModel).toList();
  }

  @override
  Future<TimesheetModel?> getById(int id) async {
    final query = createJoinQuery()
      ..where((table as $AnalyticLinesTable).backendId.equals(backendId) &
          (table as $AnalyticLinesTable).id.equals(id));

    final result = await query.getSingleOrNull();
    return result != null ? mapRowToModel(result) : null;
  }
}

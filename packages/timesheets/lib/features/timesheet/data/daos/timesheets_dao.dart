import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

part 'timesheets_dao.g.dart';

@DriftAccessor(tables: [
  Timesheets,
  ExternalTimesheets,
  ExternalTasks,
  ExternalProjects,
  Tasks,
  Projects
])
class TimesheetsDao extends DatabaseAccessor<AppDatabase>
    with _$TimesheetsDaoMixin {
  TimesheetsDao(AppDatabase db) : super(db);

  Future<List<Timesheet>> getAllTimesheets() => select(timesheets).get();

  Future<List<Timesheet>> getPaginatedTimesheets(int limit, int? offset) =>
      (select(timesheets)..limit(limit, offset: offset)).get();

  Future<int> createTimesheet(TimesheetsCompanion timesheetsCompanion) =>
      into(timesheets).insert(timesheetsCompanion);

  Future<void> updateTimesheet(Timesheet timesheet) =>
      update(timesheets).replace(
        timesheet.copyWith(
          updatedAt: DateTime.now(),
        ),
      );

  Future<int> deleteTimesheet(Timesheet timesheet) =>
      delete(timesheets).delete(timesheet);

  Future<Timesheet?> getTimesheetById(int timesheetId) =>
      (select(timesheets)..where((t) => t.id.equals(timesheetId)))
          .getSingleOrNull();

  Future<TimesheetWithTaskExternalData?> getTimesheetWithTaskProjectDataById(
      int timesheetId) async {
    final query = select(timesheets).join([
      leftOuterJoin(externalTimesheets,
          timesheets.id.equalsExp(externalTimesheets.internalId)),
      leftOuterJoin(tasks, tasks.id.equalsExp(timesheets.taskId)),
      leftOuterJoin(
          externalTasks, tasks.id.equalsExp(externalTasks.internalId)),
      leftOuterJoin(projects, tasks.projectId.equalsExp(projects.id)),
      leftOuterJoin(
          externalProjects, projects.id.equalsExp(externalProjects.internalId)),
    ])
      ..where(timesheets.id.equals(timesheetId));

    final result =
        await query.map(_rowToTimesheetWithTaskExternalData).getSingleOrNull();

    return result;
  }

  Future<List<TimesheetWithTaskExternalData>>
      getTimesheetWithTaskProjectDataListByTaskId(int taskId,
          {bool? hasStarted, bool? hasEnded}) async {
    final query = select(timesheets).join([
      leftOuterJoin(externalTimesheets,
          timesheets.id.equalsExp(externalTimesheets.internalId)),
      leftOuterJoin(tasks, tasks.id.equalsExp(timesheets.taskId)),
      leftOuterJoin(
          externalTasks, tasks.id.equalsExp(externalTasks.internalId)),
      leftOuterJoin(projects, tasks.projectId.equalsExp(projects.id)),
      leftOuterJoin(
          externalProjects, projects.id.equalsExp(externalProjects.internalId)),
    ])
      ..where(
        timesheets.taskId.equals(taskId),
      );
    if (hasStarted == true) {
      query.where(timesheets.startTime.isNotNull());
    } else if (hasStarted == false) {
      query.where(timesheets.startTime.isNull());
    }

    if (hasEnded == true) {
      query.where(timesheets.endTime.isNotNull());
    } else if (hasEnded == false) {
      query.where(timesheets.endTime.isNull());
    }

    final result = await query.map(_rowToTimesheetWithTaskExternalData).get();

    return result;
  }

  Future<List<Timesheet>> getTimesheetsByTaskId(int taskId) =>
      (select(timesheets)..where((t) => t.taskId.equals(taskId))).get();

  Future<List<Timesheet>> getTimesheetsByIds(List<int> ids) =>
      (select(timesheets)..where((t) => t.id.isIn(ids))).get();

  Future<void> batchUpdateTimesheets(List<Timesheet> timesheets) async {
    await batch((batch) {
      for (final timesheet in timesheets) {
        batch.update(
          this.timesheets,
          timesheet.copyWith(
            updatedAt: DateTime.now(),
          ),
          where: (table) => table.id.equals(timesheet.id),
        );
      }
    });
  }

  Future<void> createTimesheetWithExternal(
      {required TimesheetsCompanion timesheetsCompanion,
      required ExternalTimesheetsCompanion externalTimesheetsCompanion}) async {
    await transaction(() async {
      final timesheetId = await createTimesheet(timesheetsCompanion);
      await into(externalTimesheets).insert(
          externalTimesheetsCompanion.copyWith(internalId: Value(timesheetId)));
    });
  }

  Future<List<Timesheet>> getTimesheetsByTaskIds(List<int> taskIds) =>
      (select(timesheets)..where((t) => t.taskId.isIn(taskIds))).get();

  Future<List<TimesheetWithTaskExternalData>>
      getPaginatedTimesheetWithTaskProjectData({
    int? limit,
    int? offset,
    bool? isLocal,
    int? taskId,
    bool? isEndDateNull,
    bool? isProjectLocal,
    List<OrderingTerm Function($TimesheetsTable)>? orderBy,
    bool? isFavorite,
  }) async {
    assert(isLocal == null || isProjectLocal == null, 'Invalid query');
    final query = select(timesheets);
    // orderBy if currentStatus is running and then by latest createdAt date
    query.orderBy([
      // if currentStatus is running, then it should be the first item
      (timesheets) => OrderingTerm(
            expression: timesheets.currentStatus.equals(
              TimesheetStatusEnum.running.index,
            ),
            mode: OrderingMode.desc,
          ),

      ...orderBy ?? [],
    ]);

    if (taskId != null) {
      query.where((timesheets) => timesheets.taskId.equals(taskId));
    }

    if (isEndDateNull == true) {
      query.where((timesheets) => timesheets.endTime.isNull());
    } else if (isEndDateNull == false) {
      query.where((timesheets) => timesheets.endTime.isNotNull());
    }

    if (limit != null && offset != null) {
      query.limit(limit, offset: offset);
    }

    if (isFavorite != null) {
      query.where((timesheets) => timesheets.isFavorite.equals(isFavorite));
    }

    if (isProjectLocal == true) {
      // fetch timesheets which have projects with id as the externalProjects' internalIds
      query.where((timesheets) {
        final subquery = selectOnly(projects)
          ..addColumns([projects.id, externalProjects.internalId]);
        return notExistsQuery(subquery
          ..where(externalProjects.internalId.equalsExp(timesheets.projectId)));
      });
    } else if (isProjectLocal == false) {
      query.where((timesheets) {
        final subquery = selectOnly(projects)
          ..addColumns([projects.id, externalProjects.internalId]);
        return existsQuery(subquery
          ..where(externalProjects.internalId.equalsExp(timesheets.projectId)));
      });
    }

    if (isLocal == true) {
      // make sure that none of the externalProjects have internalId as the project's ids
      query.where((timesheets) {
        final subquery = selectOnly(externalTimesheets)
          ..addColumns([externalTimesheets.internalId]);
        return notExistsQuery(subquery
          ..where(externalTimesheets.internalId.equalsExp(timesheets.id)));
      });
    } else if (isLocal == false) {
      // fetch only projects that have externalProjects
      query.where((timesheets) {
        final subquery = selectOnly(externalTimesheets)
          ..addColumns([externalTimesheets.internalId]);
        return existsQuery(subquery
          ..where(externalTimesheets.internalId.equalsExp(timesheets.id)));
      });
    }

    final result = await (query.join(
      [
        leftOuterJoin(externalTimesheets,
            timesheets.id.equalsExp(externalTimesheets.internalId)),
        leftOuterJoin(tasks, tasks.id.equalsExp(timesheets.taskId)),
        leftOuterJoin(
            externalTasks, tasks.id.equalsExp(externalTasks.internalId)),
        leftOuterJoin(projects, tasks.projectId.equalsExp(projects.id)),
        leftOuterJoin(externalProjects,
            projects.id.equalsExp(externalProjects.internalId)),
      ],
    ))
        .map(
          (p0) => _rowToTimesheetWithTaskExternalData(p0),
        )
        .get();

    return result;
  }

  TimesheetWithTaskExternalData _rowToTimesheetWithTaskExternalData(
      TypedResult row) {
    final timesheet = row.readTable(timesheets);
    final externalTimesheet = row.readTableOrNull(externalTimesheets);
    final task = row.readTable(tasks);
    final externalTask = row.readTableOrNull(externalTasks);
    final project = row.readTable(projects);
    final externalProject = row.readTableOrNull(externalProjects);

    final timesheetExternalData = TimesheetExternalData(
      timesheet: timesheet,
      externalTimesheet: externalTimesheet,
    );

    final taskWithProjectExternalData = TaskWithExternalData(
      task: task,
      externalTask: externalTask,
    );

    final projectWithExternalData = ProjectWithExternalData(
      project: project,
      externalProject: externalProject,
    );

    return TimesheetWithTaskExternalData(
      timesheetExternalData: timesheetExternalData,
      taskWithProjectExternalData: TaskWithProjectExternalData(
        taskWithExternalData: taskWithProjectExternalData,
        projectWithExternalData: projectWithExternalData,
      ),
    );
  }

  Future<List<TimesheetExternalData>> getPaginatedTimesheetExternalData(
      {int? limit, int? offset, int? taskId, bool? isEndDateNull}) async {
    final query = select(timesheets)
      ..orderBy([
        (t) => OrderingTerm.desc(
              t.currentStatus.equals(
                TimesheetStatusEnum.running.index,
              ),
            ),
        (t) => OrderingTerm(
              expression: t.createdAt,
              mode: OrderingMode.asc,
            )
      ]);
    if (taskId != null) {
      query.where((timesheets) => timesheets.taskId.equals(taskId));
    }

    if (limit != null && offset != null) {
      query.limit(limit, offset: offset);
    }

    if (isEndDateNull == true) {
      query.where((timesheets) => timesheets.endTime.isNull());
    } else if (isEndDateNull == false) {
      query.where((timesheets) => timesheets.endTime.isNotNull());
    }

    final result = await (query.join(
      [
        leftOuterJoin(externalTimesheets,
            timesheets.id.equalsExp(externalTimesheets.internalId)),
      ],
    )).map(
      (row) {
        final timesheet = row.readTable(timesheets);
        final externalTimesheet = row.readTableOrNull(externalTimesheets);

        return TimesheetExternalData(
          timesheet: timesheet,
          externalTimesheet: externalTimesheet,
        );
      },
    ).get();

    return result;
  }

  Future<TimesheetExternalData?> getTimesheetExternalDataById(int id) =>
      (select(timesheets)..where((t) => t.id.equals(id))).join(
        [
          leftOuterJoin(externalTimesheets,
              timesheets.id.equalsExp(externalTimesheets.internalId)),
        ],
      ).map(
        (row) {
          final timesheet = row.readTable(timesheets);
          final externalTimesheet = row.readTableOrNull(externalTimesheets);

          return TimesheetExternalData(
            timesheet: timesheet,
            externalTimesheet: externalTimesheet,
          );
        },
      ).getSingleOrNull();

  Future<void> updateTimesheetsProjectAndTaskIds({
    required int oldProjectId,
    required int oldTaskId,
    required int updatedProjectId,
    required int updatedTaskId,
  }) async =>
      (update(timesheets)
            ..where((t) =>
                t.projectId.equals(oldProjectId) & t.taskId.equals(oldTaskId)))
          .write(
        TimesheetsCompanion(
          projectId: Value(updatedProjectId),
          taskId: Value(updatedTaskId),
        ),
      );
}

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
      update(timesheets).replace(timesheet);

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

    final result = await query.map((row) {
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
    }).getSingleOrNull();

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

    final result = await query.map((row) {
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
    }).get();

    return result;
  }

  Future<List<Timesheet>> getTimesheetsByTaskId(int taskId) =>
      (select(timesheets)..where((t) => t.taskId.equals(taskId))).get();
}

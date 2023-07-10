import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/task/task.dart';

part 'timesheets_dao.g.dart';

@DriftAccessor(tables: [Timesheets])
class TimesheetsDao extends DatabaseAccessor<AppDatabase>
    with _$TimesheetsDaoMixin {
  TimesheetsDao(AppDatabase db) : super(db);

  // Timesheets CRUD operations
  Future<int> createTimesheet(TimesheetsCompanion timesheetsCompanion) =>
      into(timesheets).insert(timesheetsCompanion);

  Future<void> deleteTimesheet(Timesheet timesheet) =>
      delete(timesheets).delete(timesheet);

  Future<void> deleteTimesheetsByTaskId(int taskId) =>
      (delete(timesheets)..where((th) => th.taskId.equals(taskId))).go();

  Future<List<Timesheet>> getTimesheets(int? taskId) => taskId == null
      ? select(timesheets).get()
      : (select(timesheets)..where((th) => th.taskId.equals(taskId))).get();

  Future<void> updateTimesheet(Timesheet timesheet) =>
      update(timesheets).replace(timesheet);

  Future<Timesheet?> getTimesheetById(int timesheetId) =>
      (select(timesheets)..where((th) => th.id.equals(timesheetId)))
          .getSingleOrNull();
}

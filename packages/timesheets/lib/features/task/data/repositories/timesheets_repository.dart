import 'package:timesheets/features/app/app.dart';

import 'package:timesheets/features/task/task.dart';

class TimesheetsRepository {
  final TimesheetsDao timesheetsDao;

  const TimesheetsRepository(this.timesheetsDao);

  Future<int> createTimeSheet(TimesheetsCompanion timesheetsCompanion) =>
      timesheetsDao.createTimesheet(timesheetsCompanion);

  Future<void> deleteTimesheet(Timesheet timesheet) =>
      timesheetsDao.deleteTimesheet(timesheet);

  Future<void> deleteTimesheetsByTaskId(int taskId) =>
      timesheetsDao.deleteTimesheetsByTaskId(taskId);

  Future<List<Timesheet>> getTimesheets(int? taskId) =>
      timesheetsDao.getTimesheets(taskId);

  Future<void> updateTimesheet(Timesheet timesheet) =>
      timesheetsDao.updateTimesheet(timesheet);

  Future<Timesheet?> getTimesheetById(int timesheetId) =>
      timesheetsDao.getTimesheetById(timesheetId);
}

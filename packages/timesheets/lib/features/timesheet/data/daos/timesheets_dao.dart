import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

part 'timesheets_dao.g.dart';

@DriftAccessor(tables: [Timesheets])
class TimesheetsDao extends DatabaseAccessor<AppDatabase>
    with _$TimesheetsDaoMixin {
  TimesheetsDao(AppDatabase db) : super(db);

  Future<List<Timesheet>> getAllTimesheets() => select(timesheets).get();

  Future insertTimesheet(TimesheetsCompanion timesheetsCompanion) =>
      into(timesheets).insert(timesheetsCompanion);

  Future updateTimesheet(Timesheet timesheet) =>
      update(timesheets).replace(timesheet);

  Future deleteTimesheet(Timesheet timesheet) =>
      delete(timesheets).delete(timesheet);
}

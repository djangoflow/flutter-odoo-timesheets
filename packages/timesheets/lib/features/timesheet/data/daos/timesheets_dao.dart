import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

part 'timesheets_dao.g.dart';

@DriftAccessor(tables: [Timesheets])
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
}

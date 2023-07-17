import 'package:timesheets/features/app/app.dart';

import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetsRepository
    extends CrudRepository<Timesheet, TimesheetsCompanion> {
  final TimesheetsDao timesheetsDao;

  const TimesheetsRepository(this.timesheetsDao);

  @override
  Future<int> create(TimesheetsCompanion companion) =>
      timesheetsDao.createTimesheet(companion);

  @override
  Future<int> delete(Timesheet entity) => timesheetsDao.deleteTimesheet(entity);

  @override
  Future<Timesheet?> getItemById(int id) => timesheetsDao.getTimesheetById(id);

  @override
  Future<List<Timesheet>> getItems() => timesheetsDao.getAllTimesheets();

  @override
  Future<List<Timesheet>> getPaginatedItems(
          {int? offset = 0, int limit = 50}) =>
      timesheetsDao.getPaginatedTimesheets(limit, offset);

  @override
  Future<void> update(Timesheet entity) =>
      timesheetsDao.updateTimesheet(entity);
}

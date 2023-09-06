import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features_refactored/app/data/dao.dart';
import 'package:timesheets/features_refactored/app/data/data_source.dart';

import 'package:timesheets/features_refactored/timesheet/data/entities/timesheet_entity.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetDriftDataSource implements DataSource<TimesheetEntity> {
  final Dao<Timesheet, TimesheetsCompanion> dao;

  TimesheetDriftDataSource({required this.dao});
  @override
  Future<int> delete(int id) => dao.deleteEntity(id);

  @override
  Future<List<TimesheetEntity>> getAll() => dao.getAll().then(
        (value) => value.map((e) => e.toTimesheetEntity()).toList(),
      );

  @override
  Future<TimesheetEntity?> getById(int id) => dao.getById(id).then(
        (value) => value?.toTimesheetEntity(),
      );

  @override
  Future<List<TimesheetEntity>> getPaginatedItems(
          {int? offset, int? limit, String? search}) =>
      dao
          .getPaginatedEntities(offset: offset, limit: limit, search: search)
          .then(
            (value) => value.map((e) => e.toTimesheetEntity()).toList(),
          );

  @override
  Future<int> insert(TimesheetEntity entity) =>
      dao.insertEntity(entity.toTimesheetCompanion());

  @override
  Future<bool> update(TimesheetEntity entity) =>
      dao.updateEntity(entity.toTimesheet());
}

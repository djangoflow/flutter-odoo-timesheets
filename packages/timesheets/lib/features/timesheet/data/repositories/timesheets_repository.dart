import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/data/models/odoo_timesheet.dart';

import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetRepository
    extends CrudRepository<Timesheet, TimesheetsCompanion> {
  final TimesheetsDao timesheetsDao;
  final ExternalTimesheetsDao externalTimesheetsDao;
  const TimesheetRepository({
    required this.timesheetsDao,
    required this.externalTimesheetsDao,
  });

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

  Future<TimesheetWithTaskExternalData?> getTimesheetWithTaskExternalDataById(
          int timesheetId) =>
      timesheetsDao.getTimesheetWithTaskProjectDataById(timesheetId);

  Future<List<Timesheet>> getItemsByTaskId(int timesheetId) =>
      timesheetsDao.getTimesheetsByTaskId(timesheetId);

  Future<void> syncWithOdooTimesheets({
    required Map<OdooTimesheet, Task> odooTimesheetsWithTasksMap,
  }) async {
    final odooTimesheets = odooTimesheetsWithTasksMap.keys.toList();
    final odooTimesheetsIds = odooTimesheets.map((e) => e.id).toList();
    final externalTimesheets =
        await externalTimesheetsDao.getExternalTimesheetsByIds(
      odooTimesheetsIds,
    );
    final internalTimesheetIds =
        externalTimesheets.map((e) => e.internalId).whereType<int>().toList();
    final internalTimesheets = await timesheetsDao.getTimesheetsByIds(
      internalTimesheetIds,
    );
    final updatableTimesheets = <Timesheet>[];
    final insertableTimesheetCompanions = <int, TimesheetsCompanion>{};

    for (final odooTimesheet in odooTimesheets) {
      final externalTimesheet = externalTimesheets.firstWhereOrNull(
        (e) => e.externalId == odooTimesheet.id,
      );

      if (externalTimesheet != null) {
        final internalTimesheet = internalTimesheets.firstWhereOrNull(
          (e) => e.id == externalTimesheet.internalId,
        );
        if (internalTimesheet != null) {
          updatableTimesheets.add(
            internalTimesheet.copyWith(
              endTime: Value(odooTimesheet.endTime),
              name: Value(odooTimesheet.name),
              startTime: Value(odooTimesheet.startTime),
              unitAmount: Value(odooTimesheet.unitAmount),
            ),
          );
        }
      } else {
        insertableTimesheetCompanions[odooTimesheet.id] = TimesheetsCompanion(
          endTime: Value(odooTimesheet.endTime),
          name: Value(odooTimesheet.name),
          startTime: Value(odooTimesheet.startTime),
          unitAmount: Value(odooTimesheet.unitAmount),
          taskId: Value(odooTimesheetsWithTasksMap[odooTimesheet]?.id),
          projectId:
              Value(odooTimesheetsWithTasksMap[odooTimesheet]?.projectId),
        );
      }
    }

    await timesheetsDao.batchUpdateTimesheets(updatableTimesheets);
    for (final entry in insertableTimesheetCompanions.entries) {
      final externalProjectComapanion = ExternalTimesheetsCompanion(
        externalId: Value(entry.key),
      );
      await timesheetsDao.createTimesheetWithExternal(
        timesheetsCompanion: entry.value,
        externalTimesheetsCompanion: externalProjectComapanion,
      );
    }

    debugPrint('Updated ${updatableTimesheets.length} Timesheets');
    debugPrint('Inserted ${insertableTimesheetCompanions.length} Timesheets');
  }

  Future<List<Timesheet>> getTimesheetsByTaskIds(List<int> taskIds) =>
      timesheetsDao.getTimesheetsByTaskIds(taskIds);
}

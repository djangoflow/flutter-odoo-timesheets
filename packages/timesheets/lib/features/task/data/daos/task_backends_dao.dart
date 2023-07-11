import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

part 'task_backends_dao.g.dart';

@DriftAccessor(tables: [TimesheetBackends])
class TimesheetBackendsDao extends DatabaseAccessor<AppDatabase>
    with _$TimesheetBackendsDaoMixin {
  TimesheetBackendsDao(AppDatabase db) : super(db);

  // TimesheetBackend CRUD operations
  Future<int> createTimesheetBackend(
          TimesheetBackendsCompanion timesheetBackendsCompanion) =>
      into(timesheetBackends).insert(timesheetBackendsCompanion);

  Future<void> deleteTimesheetBackend(TimesheetBackend timesheetBackend) =>
      delete(timesheetBackends).delete(timesheetBackend);

  Future<void> deleteTimesheetBackendByTimesheetId(int timesheetId) =>
      (delete(timesheetBackends)
            ..where((tb) => tb.timesheetId.equals(timesheetId)))
          .go();

  Future<void> deleteTimesheetBackendByBackendId(int backendId) =>
      (delete(timesheetBackends)..where((tb) => tb.backendId.equals(backendId)))
          .go();

  Future<List<TimesheetBackend>> getTimesheetBackendByTimesheetId(
          int timesheetId) =>
      (select(timesheetBackends)
            ..where((tb) => tb.timesheetId.equals(timesheetId)))
          .get();

  Future<List<TimesheetBackend>> getTimesheetBackendByBackendId(
          int backendId) =>
      (select(timesheetBackends)..where((tb) => tb.backendId.equals(backendId)))
          .get();

  Future<List<TimesheetBackend>> getAllTimesheetBackend() =>
      select(timesheetBackends).get();

  Future<void> updateTimesheetBackend(TimesheetBackend taskBackend) =>
      update(timesheetBackends).replace(taskBackend);
}

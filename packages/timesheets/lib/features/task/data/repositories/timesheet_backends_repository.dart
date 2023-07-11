import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class TimesheetBackendRepository {
  final TimesheetBackendsDao timesheetBackendsDao;

  const TimesheetBackendRepository(
    this.timesheetBackendsDao,
  );

  Future<int> createTimesheetBackend(
          TimesheetBackendsCompanion timesheetBackendsCompanion) =>
      timesheetBackendsDao.createTimesheetBackend(timesheetBackendsCompanion);

  Future<void> deleteTimesheetBackend(TimesheetBackend taskBackend) =>
      timesheetBackendsDao.deleteTimesheetBackend(taskBackend);

  Future<void> deleteTimesheetBackendByTimesheetId(int timesheetId) =>
      timesheetBackendsDao.deleteTimesheetBackendByTimesheetId(timesheetId);

  Future<void> deleteTimesheetBackendByBackendId(int backendId) =>
      timesheetBackendsDao.deleteTimesheetBackendByBackendId(backendId);

  Future<List<TimesheetBackend>> getTimesheetBackendByTimesheetId(
          int timesheetId) =>
      timesheetBackendsDao.getTimesheetBackendByTimesheetId(timesheetId);

  Future<List<TimesheetBackend>> getTimesheetBackendByBackendId(
          int backendId) =>
      timesheetBackendsDao.getTimesheetBackendByBackendId(backendId);

  Future<List<TimesheetBackend>> getAllTimesheetBackend() =>
      timesheetBackendsDao.getAllTimesheetBackend();

  Future<void> updateTimesheetBackend(TimesheetBackend taskBackend) =>
      timesheetBackendsDao.updateTimesheetBackend(taskBackend);
}

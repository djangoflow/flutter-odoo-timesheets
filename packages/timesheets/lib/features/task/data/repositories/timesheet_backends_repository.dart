import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class TaskBackendRepository {
  final TaskBackendsDao taskBackendsDao;

  const TaskBackendRepository(
    this.taskBackendsDao,
  );

  Future<int> createTaskBackend(TaskBackendsCompanion taskBackendsCompanion) =>
      taskBackendsDao.createTaskBackend(taskBackendsCompanion);

  Future<void> deleteTaskBackend(TaskBackend taskBackend) =>
      taskBackendsDao.deleteTaskBackend(taskBackend);

  Future<void> deleteTaskBackendByTaskId(int taskId) =>
      taskBackendsDao.deleteTaskBackendByTaskId(taskId);

  Future<void> deleteTaskBackendByBackendId(int backendId) =>
      taskBackendsDao.deleteTaskBackendByBackendId(backendId);

  Future<TaskBackend?> getTaskBackendByTaskId(int taskId) =>
      taskBackendsDao.getTaskBackendByTaskId(taskId);

  Future<List<TaskBackend>> getTaskBackendListByBackendId(int backendId) =>
      taskBackendsDao.getTaskBackendListByBackendId(backendId);

  Future<List<TaskBackend>> getAllTaskBackend() =>
      taskBackendsDao.getAllTaskBackend();

  Future<void> updateTaskBackend(TaskBackend taskBackend) =>
      taskBackendsDao.updateTaskBackend(taskBackend);
}

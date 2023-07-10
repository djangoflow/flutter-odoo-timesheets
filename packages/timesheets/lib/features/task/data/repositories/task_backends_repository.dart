import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class TaskBackendsRepository {
  final TaskBackendsDao taskBackendsDao;

  const TaskBackendsRepository(
    this.taskBackendsDao,
  );

  Future<int> createTaskBackend(TaskBackendsCompanion taskBackend) =>
      taskBackendsDao.createTaskBackend(taskBackend);

  Future<void> deleteTaskBackend(TaskBackend taskBackend) =>
      taskBackendsDao.deleteTaskBackend(taskBackend);

  Future<void> deleteTaskBackendsByTaskId(int taskId) =>
      taskBackendsDao.deleteTaskBackendsByTaskId(taskId);

  Future<void> deleteTaskBackendsByBackendId(int backendId) =>
      taskBackendsDao.deleteTaskBackendsByBackendId(backendId);

  Future<List<TaskBackend>> getTaskBackendsByTaskId(int taskId) =>
      taskBackendsDao.getTaskBackendsByTaskId(taskId);

  Future<List<TaskBackend>> getTaskBackendsByBackendId(int backendId) =>
      taskBackendsDao.getTaskBackendsByBackendId(backendId);

  Future<List<TaskBackend>> getAllTaskBackends() =>
      taskBackendsDao.getAllTaskBackends();

  Future<void> updateTaskBackend(TaskBackend taskBackend) =>
      taskBackendsDao.updateTaskBackend(taskBackend);
}

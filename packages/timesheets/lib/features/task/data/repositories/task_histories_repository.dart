import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class TaskHistoriesRepository {
  final TaskHistoriesDao taskHistoriesDao;

  const TaskHistoriesRepository(this.taskHistoriesDao);

  Future<int> createTaskHistory(TaskHistoriesCompanion taskHistory) =>
      taskHistoriesDao.createTaskHistory(taskHistory);

  Future<void> deleteTaskHistory(TaskHistory taskHistory) =>
      taskHistoriesDao.deleteTaskHistory(taskHistory);

  Future<void> deleteTaskHistoriesByTaskId(int taskId) =>
      taskHistoriesDao.deleteTaskHistoriesByTaskId(taskId);

  Future<List<TaskHistory>> getTaskHistories(int? taskId) =>
      taskHistoriesDao.getTaskHistories(taskId);

  Future<void> updateTaskHistory(TaskHistory taskHistory) =>
      taskHistoriesDao.updateTaskHistory(taskHistory);

  Future<TaskHistory?> getTaskHistoryById(int taskHistoryId) =>
      taskHistoriesDao.getTaskHistoryById(taskHistoryId);
}

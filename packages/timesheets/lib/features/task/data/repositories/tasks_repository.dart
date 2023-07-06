import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class TasksRepository {
  final TasksDao tasksDao;

  TasksRepository(
    this.tasksDao,
  );

  Future<int> createTask(TasksCompanion task) => tasksDao.createTask(task);

  Future<Task?> getTaskById(int taskId) => tasksDao.getTaskById(taskId);

  Future<List<Task>> getAllTasks() => tasksDao.getAllTasks();

  Future<List<Task>> getTasks(int limit, int offset) =>
      tasksDao.getTasks(limit, offset);

  Future<void> updateTask(Task task) => tasksDao.updateTask(task);

  Future<void> deleteTask(Task task) => tasksDao.deleteTask(task);
}

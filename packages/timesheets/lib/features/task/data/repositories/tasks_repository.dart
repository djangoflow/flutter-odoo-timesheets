import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class TasksRepository {
  final TasksDao tasksDao;

  TasksRepository(
    this.tasksDao,
  );

  Future<int> createTask(TasksCompanion tasksCompanion) =>
      tasksDao.createTask(tasksCompanion.copyWith(
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));

  Future<Task?> getTaskById(int taskId) => tasksDao.getTaskById(taskId);

  Future<List<Task>> getAllTasks() => tasksDao.getAllTasks();

  Future<List<Task>> getTasks([TasksListFilter? tasksListFilter]) =>
      tasksDao.getTasks(
        tasksListFilter?.limit ?? TasksListFilter.kPageSize,
        tasksListFilter?.offset,
      );

  Future<void> updateTask(Task task) => tasksDao.updateTask(
        task.copyWith(
          updatedAt: DateTime.now(),
        ),
      );

  Future<void> deleteTask(Task task) => tasksDao.deleteTask(task);
}

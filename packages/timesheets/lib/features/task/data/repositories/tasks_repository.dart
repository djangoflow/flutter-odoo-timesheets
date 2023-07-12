import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';
import 'package:timesheets/features/task/task.dart';

class TasksRepository {
  final TasksDao tasksDao;

  const TasksRepository(
    this.tasksDao,
  );

  Future<int> createTask(TasksCompanion tasksCompanion) =>
      tasksDao.createTask(tasksCompanion.copyWith(
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));

  Future<Task?> getTaskById(int taskId) => tasksDao.getTaskById(taskId);

  Future<List<Task>> getAllTasks() => tasksDao.getAllTasks();

  Future<List<Task>> getTasks(int limit, int? offset) =>
      tasksDao.getTasks(limit, offset);

  Future<List<TaskWithProject>> getTasksWithProjects(int limit, int? offset) =>
      tasksDao.getTasksWithProjects(limit, offset);

  Future<int> createTaskWithProject(
          TasksCompanion tasksCompanion, ProjectsCompanion projectsCompanion) =>
      tasksDao.createTaskWithProject(tasksCompanion, projectsCompanion);

  Future<TaskWithProject?> getTaskWithProjectById(int taskId) =>
      tasksDao.getTaskWithProjectById(taskId);

  Future<void> updateTask(Task task) => tasksDao.updateTask(
        task.copyWith(
          updatedAt: DateTime.now(),
        ),
      );

  Future<void> updateTaskWithProject({Task? task, Project? project}) =>
      tasksDao.updateTaskWithProject(
        task,
        project,
      );

  Future<void> deleteTask(Task task) => tasksDao.deleteTask(task);

  Future<void> resetTask(Task task) => tasksDao.resetTask(task);

  Future<List<Task>> getTasksWithoutBackend() =>
      tasksDao.getTasksWithoutBackend();

  Future<List<Task>> getTasksByBackendId(int backendId) =>
      tasksDao.getTasksByBackendId(backendId);
}

import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/task/task.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks, Backends, TaskBackends])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(AppDatabase db) : super(db);

  // Task CRUD operations
  Future<int> createTask(TasksCompanion task) => into(tasks).insert(task);

  Future<Task?> getTaskById(int taskId) =>
      (select(tasks)..where((t) => t.id.equals(taskId))).getSingleOrNull();

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Future<List<Task>> getTasks(int limit, int offset) => (select(tasks)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
        ..limit(limit, offset: offset))
      .get();

  Future<void> updateTask(Task task) => update(tasks).replace(task);

  Future<void> deleteTask(Task task) => delete(tasks).delete(task);
}

@DriftAccessor(tables: [Backends])
class BackendsDao extends DatabaseAccessor<AppDatabase>
    with _$BackendsDaoMixin {
  BackendsDao(AppDatabase db) : super(db);

  // Backend CRUD operations
  Future<int> createBackend(BackendsCompanion backend) =>
      into(backends).insert(backend);

  Future<Backend?> getBackendById(int backendId) =>
      (select(backends)..where((b) => b.id.equals(backendId)))
          .getSingleOrNull();

  Future<List<Backend>> getAllBackends() => select(backends).get();

  Future<void> updateBackend(Backend backend) =>
      update(backends).replace(backend);

  Future<void> deleteBackend(Backend backend) =>
      delete(backends).delete(backend);
}

@DriftAccessor(tables: [TaskBackends])
class TaskBackendsDao extends DatabaseAccessor<AppDatabase>
    with _$TaskBackendsDaoMixin {
  TaskBackendsDao(AppDatabase db) : super(db);

  // TaskBackends CRUD operations
  Future<void> createTaskBackend(TaskBackendsCompanion taskBackend) =>
      into(taskBackends).insert(taskBackend);

  Future<void> deleteTaskBackend(TaskBackend taskBackend) =>
      delete(taskBackends).delete(taskBackend);
}

import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

part 'task_backends_dao.g.dart';

@DriftAccessor(tables: [TaskBackends])
class TaskBackendsDao extends DatabaseAccessor<AppDatabase>
    with _$TaskBackendsDaoMixin {
  TaskBackendsDao(AppDatabase db) : super(db);

  // TaskBackends CRUD operations
  Future<int> createTaskBackend(TaskBackendsCompanion taskBackendsCompanion) =>
      into(taskBackends).insert(taskBackendsCompanion);

  Future<void> deleteTaskBackend(TaskBackend taskBackend) =>
      delete(taskBackends).delete(taskBackend);

  Future<void> deleteTaskBackendsByTaskId(int taskId) =>
      (delete(taskBackends)..where((tb) => tb.taskId.equals(taskId))).go();

  Future<void> deleteTaskBackendsByBackendId(int backendId) =>
      (delete(taskBackends)..where((tb) => tb.backendId.equals(backendId)))
          .go();

  Future<List<TaskBackend>> getTaskBackendsByTaskId(int taskId) =>
      (select(taskBackends)..where((tb) => tb.taskId.equals(taskId))).get();

  Future<List<TaskBackend>> getTaskBackendsByBackendId(int backendId) =>
      (select(taskBackends)..where((tb) => tb.backendId.equals(backendId)))
          .get();

  Future<List<TaskBackend>> getAllTaskBackends() => select(taskBackends).get();

  Future<void> updateTaskBackend(TaskBackend taskBackend) =>
      update(taskBackends).replace(taskBackend);
}

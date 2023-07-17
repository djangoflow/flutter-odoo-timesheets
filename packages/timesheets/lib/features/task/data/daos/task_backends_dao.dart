// import 'package:drift/drift.dart';
// import 'package:timesheets/features/app/app.dart';
// import 'package:timesheets/features/task/task.dart';

// part 'task_backends_dao.g.dart';

// @DriftAccessor(tables: [TaskBackends])
// class TaskBackendsDao extends DatabaseAccessor<AppDatabase>
//     with _$TaskBackendsDaoMixin {
//   TaskBackendsDao(AppDatabase db) : super(db);

//   // TaskBackend CRUD operations
//   Future<int> createTaskBackend(TaskBackendsCompanion taskBackendsCompanion) =>
//       into(taskBackends).insert(taskBackendsCompanion);

//   Future<void> deleteTaskBackend(TaskBackend taskBackend) =>
//       delete(taskBackends).delete(taskBackend);

//   Future<void> deleteTaskBackendByTaskId(int taskId) =>
//       (delete(taskBackends)..where((tb) => tb.taskId.equals(taskId))).go();

//   Future<void> deleteTaskBackendByBackendId(int backendId) =>
//       (delete(taskBackends)..where((tb) => tb.backendId.equals(backendId)))
//           .go();

//   Future<TaskBackend?> getTaskBackendByTaskId(int taskId) =>
//       (select(taskBackends)..where((tb) => tb.taskId.equals(taskId)))
//           .getSingleOrNull();

//   Future<List<TaskBackend>> getTaskBackendListByBackendId(int backendId) =>
//       (select(taskBackends)..where((tb) => tb.backendId.equals(backendId)))
//           .get();

//   Future<List<TaskBackend>> getAllTaskBackend() => select(taskBackends).get();

//   Future<void> updateTaskBackend(TaskBackend taskBackend) =>
//       update(taskBackends).replace(taskBackend);
// }

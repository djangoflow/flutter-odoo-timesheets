import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/task/task.dart';

part 'task_histories_dao.g.dart';

@DriftAccessor(tables: [TaskHistories])
class TaskHistoriesDao extends DatabaseAccessor<AppDatabase>
    with _$TaskHistoriesDaoMixin {
  TaskHistoriesDao(AppDatabase db) : super(db);

  // TaskHistories CRUD operations
  Future<int> createTaskHistory(
          TaskHistoriesCompanion taskHistoriesCompanion) =>
      into(taskHistories).insert(taskHistoriesCompanion);

  Future<void> deleteTaskHistory(TaskHistory taskHistory) =>
      delete(taskHistories).delete(taskHistory);

  Future<void> deleteTaskHistoriesByTaskId(int taskId) =>
      (delete(taskHistories)..where((th) => th.taskId.equals(taskId))).go();

  Future<List<TaskHistory>> getTaskHistories(int? taskId) => taskId == null
      ? select(taskHistories).get()
      : (select(taskHistories)..where((th) => th.taskId.equals(taskId))).get();

  Future<void> updateTaskHistory(TaskHistory taskHistory) =>
      update(taskHistories).replace(taskHistory);

  Future<TaskHistory?> getTaskHistoryById(int taskHistoryId) =>
      (select(taskHistories)..where((th) => th.id.equals(taskHistoryId)))
          .getSingleOrNull();
}

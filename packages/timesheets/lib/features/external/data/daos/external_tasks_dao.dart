import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

part 'external_tasks_dao.g.dart';

@DriftAccessor(tables: [ExternalTasks])
class ExternalTasksDao extends DatabaseAccessor<AppDatabase>
    with _$ExternalTasksDaoMixin {
  ExternalTasksDao(AppDatabase db) : super(db);

  // CRUD operations for ExternalTasks
  Future<int> createExternalTask(
          ExternalTasksCompanion externalTasksCompanion) =>
      into(externalTasks).insert(externalTasksCompanion);

  Future<ExternalTask?> getExternalTaskById(int externalTaskId) =>
      (select(externalTasks)..where((t) => t.id.equals(externalTaskId)))
          .getSingleOrNull();

  Future<List<ExternalTask>> getAllExternalTasks() =>
      select(externalTasks).get();

  Future<List<ExternalTask>> getPaginatedExternalTasks(
          int limit, int? offset) =>
      (select(externalTasks)..limit(limit, offset: offset)).get();

  Future<void> updateExternalTask(ExternalTask externalTask) =>
      update(externalTasks).replace(externalTask);

  Future<int> deleteExternalTask(ExternalTask externalTask) =>
      delete(externalTasks).delete(externalTask);

  Future<List<ExternalTask>> getExternalTasksByIds(List<int> externalIds) =>
      (select(externalTasks)
            ..where(
              (t) => t.externalId.isIn(externalIds),
            ))
          .get();
}

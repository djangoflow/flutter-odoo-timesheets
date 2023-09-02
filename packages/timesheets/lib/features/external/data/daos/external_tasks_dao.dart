import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

part 'external_tasks_dao.g.dart';

@DriftAccessor(tables: [ExternalTasks, ExternalProjects])
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

  /// Get all [ExternalTask] by externalTaskIds
  Future<List<ExternalTask>> getExternalTasksByIds(List<int> externalTaskIds) =>
      (select(externalTasks)
            ..where(
              (t) => t.externalId.isIn(externalTaskIds),
            ))
          .get();

  Future<ExternalTask?> getExternalTaskByExternalId(int externalId) =>
      (select(externalTasks)..where((t) => t.externalId.equals(externalId)))
          .getSingleOrNull();

  Future<List<ExternalTask>> getExternalTasksByInternalIds(
          List<int> internalIds) =>
      (select(externalTasks)..where((t) => t.internalId.isIn(internalIds)))
          .get();

  Future<void> batchDeleteExternalTasksByIds(List<int> ids) => batch((batch) {
        batch.deleteWhere(externalTasks, (t) => t.id.isIn(ids));
      });

  Future<List<ExternalTask>> getOrphanedExternalTasksForBackend(
      {required int backendId, required List<int> excludedExternalIds}) async {
    final query = select(externalTasks).join([
      innerJoin(tasks, tasks.id.equalsExp(externalTasks.internalId)),
      innerJoin(externalProjects,
          externalProjects.internalId.equalsExp(tasks.projectId)),
    ])
      ..where(externalProjects.backendId.equals(backendId))
      ..where(
        externalTasks.externalId.isNotIn(excludedExternalIds),
      );

    final rows = await query.get();
    return rows.map((row) {
      final externalTask = row.readTable(externalTasks);
      return externalTask;
    }).toList();
  }

  Future<ExternalTask?> getExternalTaskByInternalId(int internalId) =>
      (select(externalTasks)..where((t) => t.internalId.equals(internalId)))
          .getSingleOrNull();
}

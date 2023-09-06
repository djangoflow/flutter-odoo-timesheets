import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/task/data/database_tables/task.dart';
import 'package:timesheets/features_refactored/app/data/dao.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks, Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase>
    with _$TasksDaoMixin
    implements Dao<Task, TasksCompanion> {
  TasksDao(super.attachedDatabase);

  @override
  Future<List<Task>> getAll() => select(tasks).get();

  @override
  Future<Task?> getById(int id) =>
      (select(tasks)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  @override
  Future<List<Task>> getPaginatedEntities(
      {int? offset, int? limit, String? search}) {
    final query = select(tasks);
    if (limit != null) {
      query.limit(
        limit,
        offset: offset,
      );
    }

    if (search != null) {
      query.where((tbl) => tbl.name.contains(search));
    }

    return query.get();
  }

  @override
  Future<int> insertEntity(TasksCompanion insertableEntity) =>
      into(tasks).insert(insertableEntity);

  @override
  Future<bool> updateEntity(Task entity) => update(tasks).replace(entity);

  @override
  Future<int> deleteEntity(int id) =>
      (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();
}

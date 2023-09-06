import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features_refactored/app/data/dao.dart';
import 'package:timesheets/features_refactored/app/data/data_source.dart';

import 'package:timesheets/features_refactored/task/data/entities/task_entity.dart';
import 'package:timesheets/utils/utils.dart';

class TaskDriftDataSource implements DataSource<TaskEntity> {
  final Dao<Task, TasksCompanion> dao;

  TaskDriftDataSource({required this.dao});
  @override
  Future<int> delete(int id) => dao.deleteEntity(id);

  @override
  Future<List<TaskEntity>> getAll() => dao.getAll().then(
        (value) => value.map((e) => e.toTaskEntity()).toList(),
      );

  @override
  Future<TaskEntity?> getById(int id) => dao.getById(id).then(
        (value) => value?.toTaskEntity(),
      );

  @override
  Future<List<TaskEntity>> getPaginatedItems(
          {int? offset, int? limit, String? search}) =>
      dao
          .getPaginatedEntities(offset: offset, limit: limit, search: search)
          .then(
            (value) => value.map((e) => e.toTaskEntity()).toList(),
          );

  @override
  Future<int> insert(TaskEntity entity) =>
      dao.insertEntity(entity.toProjectCompanion());

  @override
  Future<bool> update(TaskEntity entity) =>
      dao.updateEntity(entity.toProject());
}

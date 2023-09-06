import 'package:timesheets/features_refactored/app/data/data_source.dart';
import 'package:timesheets/features_refactored/app/data/repository.dart';
import 'package:timesheets/features_refactored/task/data/entities/task_entity.dart';

class TaskRepository implements Repository<TaskEntity> {
  final DataSource<TaskEntity> _dataSource;

  TaskRepository(this._dataSource);
  @override
  Future<int> delete(int id) => dataSource.delete(id);

  @override
  Future<List<TaskEntity>> getAll() => dataSource.getAll();

  @override
  Future<TaskEntity?> getById(int id) => dataSource.getById(id);

  @override
  Future<List<TaskEntity>> getPaginatedItems(
          {int? offset, int? limit, String? search}) =>
      dataSource.getPaginatedItems(
          offset: offset, limit: limit, search: search);

  @override
  Future<int> insert(TaskEntity entity) => dataSource.insert(entity);

  @override
  Future<bool> update(TaskEntity entity) => dataSource.update(entity);

  @override
  DataSource<TaskEntity> get dataSource => _dataSource;
}

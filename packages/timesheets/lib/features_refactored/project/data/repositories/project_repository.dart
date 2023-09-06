import 'package:timesheets/features_refactored/app/data/repository.dart';
import 'package:timesheets/features_refactored/project/data/data_sources/project_data_source.dart';
import 'package:timesheets/features_refactored/project/data/entities/project_entity.dart';

class ProjectRepository implements Repository<ProjectEntity> {
  final ProjectDataSource _dataSource;

  ProjectRepository(this._dataSource);
  @override
  Future<int> delete(int id) => dataSource.delete(id);

  @override
  Future<List<ProjectEntity>> getAll() => dataSource.getAll();

  @override
  Future<ProjectEntity?> getById(int id) => dataSource.getById(id);

  @override
  Future<List<ProjectEntity>> getPaginatedItems(
          {int? offset, int? limit, String? search, bool? isFavorite}) =>
      dataSource.getPaginatedItems(
          offset: offset, limit: limit, search: search, isFavorite: isFavorite);

  @override
  Future<int> insert(ProjectEntity entity) => dataSource.insert(entity);

  @override
  Future<bool> update(ProjectEntity entity) => dataSource.update(entity);

  @override
  ProjectDataSource get dataSource => _dataSource;
}

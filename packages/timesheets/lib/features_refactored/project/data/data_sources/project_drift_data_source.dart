import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features_refactored/app/data/dao.dart';
import 'package:timesheets/features_refactored/app/data/data_source.dart';
import 'package:timesheets/features_refactored/project/data/entities/project_entity.dart';
import 'package:timesheets/utils/extensions/project_extensions.dart';

class ProjectDriftDataSource implements DataSource<ProjectEntity> {
  final Dao<Project, ProjectsCompanion> dao;

  ProjectDriftDataSource({required this.dao});
  @override
  Future<int> delete(int id) => dao.deleteEntity(id);

  @override
  Future<List<ProjectEntity>> getAll() => dao.getAll().then(
        (value) => value.map((e) => e.toProjectEntity()).toList(),
      );

  @override
  Future<ProjectEntity?> getById(int id) => dao.getById(id).then(
        (value) => value?.toProjectEntity(),
      );

  @override
  Future<List<ProjectEntity>> getPaginatedItems(
          {int? offset, int? limit, String? search}) =>
      dao
          .getPaginatedEntities(offset: offset, limit: limit, search: search)
          .then(
            (value) => value.map((e) => e.toProjectEntity()).toList(),
          );

  @override
  Future<int> insert(ProjectEntity entity) =>
      dao.insertEntity(entity.toProjectCompanion());

  @override
  Future<bool> update(ProjectEntity entity) =>
      dao.updateEntity(entity.toProject());
}

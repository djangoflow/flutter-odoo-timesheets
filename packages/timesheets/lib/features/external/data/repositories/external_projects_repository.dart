import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

class ExternalProjectsRepository
    extends CrudRepository<ExternalProject, ExternalProjectsCompanion> {
  final ExternalProjectsDao externalProjectsDao;

  ExternalProjectsRepository(this.externalProjectsDao);

  @override
  Future<int> create(ExternalProjectsCompanion companion) =>
      externalProjectsDao.createExternalProject(companion);

  @override
  Future<int> delete(ExternalProject entity) =>
      externalProjectsDao.deleteExternalProject(entity);

  @override
  Future<ExternalProject?> getItemById(int id) =>
      externalProjectsDao.getExternalProjectById(id);

  @override
  Future<List<ExternalProject>> getItems() =>
      externalProjectsDao.getAllExternalProjects();

  @override
  Future<List<ExternalProject>> getPaginatedItems(
          {int? offset = 0, int limit = 50}) =>
      externalProjectsDao.getPaginatedExternalProjects(limit, offset);

  @override
  Future<void> update(ExternalProject entity) => externalProjectsDao
      .updateExternalProject(entity.copyWith(updatedAt: DateTime.now()));
}

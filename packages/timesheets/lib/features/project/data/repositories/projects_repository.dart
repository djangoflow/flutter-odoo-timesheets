import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

class ProjectRepository extends CrudRepository<Project, ProjectsCompanion> {
  final ProjectsDao projectsDao;

  const ProjectRepository(
    this.projectsDao,
  );

  @override
  Future<int> create(ProjectsCompanion companion) =>
      projectsDao.createProject(companion);

  @override
  Future<int> delete(Project entity) => projectsDao.deleteProject(entity);

  @override
  Future<Project?> getItemById(int id) => projectsDao.getProjectById(id);

  @override
  Future<List<Project>> getItems() => projectsDao.getAllProjects();

  @override
  Future<List<Project>> getPaginatedItems({int? offset = 0, int limit = 50}) =>
      projectsDao.getPaginatedProjects(limit, offset);

  @override
  Future<void> update(Project entity) => projectsDao.updateProject(
        entity.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
}

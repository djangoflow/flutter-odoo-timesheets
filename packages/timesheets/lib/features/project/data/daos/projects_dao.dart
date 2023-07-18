import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/data/database_tables/project.dart';

part 'projects_dao.g.dart';

@DriftAccessor(tables: [Projects])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin {
  ProjectsDao(AppDatabase db) : super(db);

  Future<int> createProject(ProjectsCompanion projectsCompanion) =>
      into(projects).insert(projectsCompanion);

  Future<Project?> getProjectById(int projectId) =>
      (select(projects)..where((p) => p.id.equals(projectId)))
          .getSingleOrNull();

  Future<List<Project>> getAllProjects() => select(projects).get();

  Future<List<Project>> getPaginatedProjects(int limit, int? offset) =>
      (select(projects)..limit(limit, offset: offset)).get();

  Future<void> updateProject(Project project) =>
      update(projects).replace(project);

  Future<int> deleteProject(Project project) =>
      delete(projects).delete(project);
}

import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/project/data/database_tables/project.dart';

part 'projects_dao.g.dart';

@DriftAccessor(tables: [Projects, ExternalProjects])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin {
  ProjectsDao(AppDatabase db) : super(db);

  Future<int> createProject(ProjectsCompanion projectsCompanion) =>
      into(projects).insert(projectsCompanion);

  Future<void> createProjectWithExternal(
      {required ProjectsCompanion projectsCompanion,
      required ExternalProjectsCompanion externalProjectsCompanion}) async {
    await transaction(() async {
      final id = await createProject(projectsCompanion);
      await into(externalProjects).insert(
        externalProjectsCompanion.copyWith(
          internalId: Value(id),
        ),
      );
    });
  }

  Future<Project?> getProjectById(int projectId) =>
      (select(projects)..where((p) => p.id.equals(projectId)))
          .getSingleOrNull();

  Future<List<Project>> getAllProjects() => select(projects).get();

  Future<List<Project>> getPaginatedProjects({
    int? limit,
    int? offset,
    bool? isLocal,
    String? search,
  }) async {
    final query = select(projects);

    if (limit != null && offset != null) {
      query.limit(limit, offset: offset);
    }
    if (search != null && search.isNotEmpty) {
      query.where((p) => p.name.contains(search));
    }

    query.orderBy([
      (p) => OrderingTerm(expression: p.updatedAt, mode: OrderingMode.desc),
      (p) => OrderingTerm(expression: p.name, mode: OrderingMode.asc),
    ]);

    if (isLocal == true) {
      // make sure that none of the externalProjects have internalId as the project's ids
      query.where((projects) {
        final subquery = selectOnly(externalProjects)
          ..addColumns([externalProjects.internalId]);
        return notExistsQuery(subquery
          ..where(externalProjects.internalId.equalsExp(projects.id)));
      });
    } else if (isLocal == false) {
      // fetch only projects that have externalProjects
      query.where((projects) {
        final subquery = selectOnly(externalProjects)
          ..addColumns([externalProjects.internalId]);
        return existsQuery(subquery
          ..where(externalProjects.internalId.equalsExp(projects.id)));
      });
    }

    return await query.get();
  }

  Future<void> updateProject(Project project) =>
      update(projects).replace(project);

  Future<int> deleteProject(Project project) =>
      delete(projects).delete(project);

  Future<void> batchUpdateProjects(List<Project> projects) async {
    await batch((batch) {
      batch.insertAll(
        this.projects,
        projects,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<List<Project>> getProjectsByIds(List<int> ids) =>
      (select(projects)..where((p) => p.id.isIn(ids))).get();

  // Should be in external projects dao if we had one and it's internal id matches any project
  Future<Project?> getProjectByExternalId(int externalProjectId) async {
    final externalProject = await (select(externalProjects)
          ..where((p) => p.externalId.equals(externalProjectId)))
        .getSingleOrNull();
    if (externalProject != null && externalProject.internalId != null) {
      return getProjectById(externalProject.internalId!);
    } else {
      return null;
    }
  }
}

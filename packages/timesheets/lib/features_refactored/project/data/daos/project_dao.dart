import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/project/data/database_tables/project.dart';
import 'package:timesheets/features_refactored/app/data/dao.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [Projects])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin
    implements Dao<Project, ProjectsCompanion> {
  ProjectsDao(super.attachedDatabase);

  @override
  Future<List<Project>> getAll() => select(projects).get();

  @override
  Future<Project?> getById(int id) =>
      (select(projects)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  @override
  Future<List<Project>> getPaginatedEntities(
      {int? offset, int? limit, String? search}) {
    final query = select(projects);
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
  Future<int> insertEntity(ProjectsCompanion insertableEntity) =>
      into(projects).insert(insertableEntity);

  @override
  Future<bool> updateEntity(Project entity) => update(projects).replace(entity);

  @override
  Future<int> deleteEntity(int id) =>
      (delete(projects)..where((tbl) => tbl.id.equals(id))).go();
}

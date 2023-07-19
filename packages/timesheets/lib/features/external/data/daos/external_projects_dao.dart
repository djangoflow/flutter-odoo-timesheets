import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

part 'external_projects_dao.g.dart';

@DriftAccessor(tables: [ExternalProjects])
class ExternalProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ExternalProjectsDaoMixin {
  ExternalProjectsDao(AppDatabase db) : super(db);

  Future<int> createExternalProject(
          ExternalProjectsCompanion externalProjectsCompanion) =>
      into(externalProjects).insert(externalProjectsCompanion);

  Future<ExternalProject?> getExternalProjectById(int externalProjectId) =>
      (select(externalProjects)..where((p) => p.id.equals(externalProjectId)))
          .getSingleOrNull();

  Future<List<ExternalProject>> getAllExternalProjects() =>
      select(externalProjects).get();

  Future<List<ExternalProject>> getPaginatedExternalProjects(
          int limit, int? offset) =>
      (select(externalProjects)..limit(limit, offset: offset)).get();

  Future<void> updateExternalProject(ExternalProject externalProject) =>
      update(externalProjects).replace(externalProject);

  Future<int> deleteExternalProject(ExternalProject externalProject) =>
      delete(externalProjects).delete(externalProject);

  Future<List<ExternalProject>> getExternalProjectsByIdsAndBackendId(
          {required int backendId, required List<int> externalIds}) =>
      (select(externalProjects)
            ..where((p) => p.backendId.equals(backendId))
            ..where((p) => p.externalId.isIn(externalIds)))
          .get();
}

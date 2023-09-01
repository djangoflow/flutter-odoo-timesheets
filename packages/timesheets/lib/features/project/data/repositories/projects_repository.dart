import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/data/models/odoo_project.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:collection/collection.dart';

class ProjectRepository extends CrudRepository<Project, ProjectsCompanion> {
  final ProjectsDao projectsDao;
  final ExternalProjectsDao externalProjectsDao;

  const ProjectRepository({
    required this.projectsDao,
    required this.externalProjectsDao,
  });

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
  Future<List<Project>> getPaginatedItems({
    int? offset,
    int? limit,
    bool? isLocal,
    String? search,
  }) =>
      projectsDao.getPaginatedProjects(
        limit: limit,
        offset: offset,
        isLocal: isLocal,
        search: search,
      );

  @override
  Future<void> update(Project entity) => projectsDao.updateProject(
        entity.copyWith(
          updatedAt: DateTime.now(),
        ),
      );

  Future<ProjectWithExternalData> getProjectWithExternalDataById(int id) =>
      projectsDao.getProjectWithExternalDataById(id);

  Future<List<ProjectWithExternalData>> getPaginatedProjectsWithExternalData({
    int? offset,
    int? limit,
    bool? isLocal,
    String? search,
    bool? isFavorite,
  }) =>
      projectsDao.getPaginatedProjectsWithExternalData(
        offset: offset,
        isLocal: isLocal,
        limit: limit,
        search: search,
        isFavorite: isFavorite,
      );

  Future<void> syncWithOdooProjects(
      {required int backendId, required List<OdooProject> odooProjects}) async {
    final odooProjectIds = odooProjects.map((e) => e.id).toList();
    final externalProjects =
        await externalProjectsDao.getExternalProjectsByIdsAndBackendId(
      backendId: backendId,
      externalIds: odooProjectIds,
    );
    final internalProjectIds =
        externalProjects.map((e) => e.internalId).whereType<int>().toList();
    final internalProjects = await projectsDao.getProjectsByIds(
      internalProjectIds,
    );
    final updatableProjects = <Project>[];
    final insertableProjectCompanions = <int, ProjectsCompanion>{};

    for (final odooProject in odooProjects) {
      final externalProject = externalProjects.firstWhereOrNull(
        (e) => e.externalId == odooProject.id,
      );

      if (externalProject != null) {
        final internalProject = internalProjects.firstWhereOrNull(
          (e) => e.id == externalProject.internalId,
        );
        if (internalProject != null) {
          updatableProjects.add(
            internalProject.copyWith(
              active: Value(odooProject.active),
              color: Value(odooProject.color),
              isFavorite: Value(odooProject.isFavorite),
              name: Value(odooProject.name),
              taskCount: Value(odooProject.taskCount),
              updatedAt: DateTime.now(),
            ),
          );
        }
      } else {
        insertableProjectCompanions[odooProject.id] = ProjectsCompanion(
          active: Value(odooProject.active),
          color: Value(odooProject.color),
          isFavorite: Value(odooProject.isFavorite),
          name: Value(odooProject.name),
          taskCount: Value(odooProject.taskCount),
        );
      }
    }

    await projectsDao.batchUpdateProjects(updatableProjects);
    for (final entry in insertableProjectCompanions.entries) {
      final externalProjectComapanion = ExternalProjectsCompanion(
        backendId: Value(backendId),
        externalId: Value(entry.key),
      );
      await projectsDao.createProjectWithExternal(
        projectsCompanion: entry.value,
        externalProjectsCompanion: externalProjectComapanion,
      );
    }

    debugPrint('Updated ${updatableProjects.length} projects');
    debugPrint('Inserted ${insertableProjectCompanions.length} projects');
  }

  Future<Project?> getProjectByExternalId(int externalProjectId) =>
      projectsDao.getProjectByExternalId(externalProjectId);

  Future<List<Project>> getProjectsByIds(List<int> ids) =>
      projectsDao.getProjectsByIds(ids);
}

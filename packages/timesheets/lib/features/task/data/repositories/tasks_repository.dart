import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/task/task.dart';

import 'package:collection/collection.dart';

class TaskRepository extends CrudRepository<Task, TasksCompanion> {
  final TasksDao tasksDao;
  final ExternalTasksDao externalTasksDao;
  const TaskRepository({
    required this.tasksDao,
    required this.externalTasksDao,
  });

  @override
  Future<int> create(TasksCompanion companion) =>
      tasksDao.createTask(companion);

  @override
  Future<Task?> getItemById(int id) => tasksDao.getTaskById(id);

  @override
  Future<List<Task>> getPaginatedItems({int limit = 50, int? offset}) =>
      tasksDao.getPaginatedTasks(limit, offset);

  @override
  Future<List<Task>> getItems() => tasksDao.getAllTasks();

  Future<List<TaskWithProjectExternalData>> getPaginatedTasksWithProjects(
    int limit,
    int? offset,
    int? projectId,
    String? search,
  ) =>
      tasksDao.getPaginatedTasksWithProjects(
        limit: limit,
        offset: offset,
        projectId: projectId,
        search: search,
      );

  Future<List<TaskWithProjectExternalData>> getAllTasksWithProjects() =>
      tasksDao.getAllTasksWithProjects();

  Future<int> createTaskWithProject(
          TasksCompanion tasksCompanion, ProjectsCompanion projectsCompanion) =>
      tasksDao.createTaskWithProject(tasksCompanion, projectsCompanion);

  Future<TaskWithProjectExternalData?> getTaskWithProjectById(int taskId) =>
      tasksDao.getTaskWithProjectById(taskId);

  Future<void> deleteTask(Task task) => tasksDao.deleteTask(task);

  @override
  Future<int> delete(Task entity) => tasksDao.deleteTask(entity);

  @override
  Future<void> update(Task entity) => tasksDao.updateTask(
        entity.copyWith(
          updatedAt: DateTime.now(),
        ),
      );

  Future<void> syncWithOdooTasks({
    required Map<OdooTask, Project> odooTasksWithProjectsMap,
  }) async {
    final odooTasks = odooTasksWithProjectsMap.keys.toList();
    final odooTaskIds = odooTasks.map((e) => e.id).toList();
    final externalTasks = await externalTasksDao.getExternalTasksByIds(
      odooTaskIds,
    );
    final internalTaskIds =
        externalTasks.map((e) => e.internalId).whereType<int>().toList();
    final internalTasks = await tasksDao.getTasksByIds(
      internalTaskIds,
    );
    final updatableTasks = <Task>[];
    final insertableTaskCompanions = <int, TasksCompanion>{};

    for (final odooTask in odooTasks) {
      final externalTask = externalTasks.firstWhereOrNull(
        (e) => e.externalId == odooTask.id,
      );

      if (externalTask != null) {
        final internalTask = internalTasks.firstWhereOrNull(
          (e) => e.id == externalTask.internalId,
        );
        if (internalTask != null) {
          updatableTasks.add(
            internalTask.copyWith(
              active: Value(odooTask.active),
              dateDeadline: Value(odooTask.dateDeadline),
              dateEnd: Value(odooTask.dateEnd),
              dateStart: Value(odooTask.dateStart),
              priority: Value(odooTask.priority),
              name: Value(odooTask.name),
              description: Value(odooTask.description),
            ),
          );
        }
      } else {
        insertableTaskCompanions[odooTask.id] = TasksCompanion(
          active: Value(odooTask.active),
          projectId: Value(odooTasksWithProjectsMap[odooTask]!.id),
          name: Value(odooTask.name),
          dateDeadline: Value(odooTask.dateDeadline),
          dateEnd: Value(odooTask.dateEnd),
          dateStart: Value(odooTask.dateStart),
          priority: Value(odooTask.priority),
          description: Value(odooTask.description),
        );
      }
    }

    await tasksDao.batchUpdateTasks(updatableTasks);
    for (final entry in insertableTaskCompanions.entries) {
      final externalProjectComapanion = ExternalTasksCompanion(
        externalId: Value(entry.key),
      );
      await tasksDao.createTaskWithExternal(
        tasksCompanion: entry.value,
        externalTasksCompanion: externalProjectComapanion,
      );
    }

    debugPrint('Updated ${updatableTasks.length} Tasks');
    debugPrint('Inserted ${insertableTaskCompanions.length} Tasks');
  }

  Future<Task?> getTaskByExternalId(int externalTaskId) async {
    final externalTask =
        await externalTasksDao.getExternalTaskByExternalId(externalTaskId);
    if (externalTask != null && externalTask.internalId != null) {
      return tasksDao.getTaskById(externalTask.internalId!);
    } else {
      debugPrint('Task with external id $externalTaskId not found');
    }
    return null;
  }

  Future<List<Task>> getTasksByProjectIds(List<int> projectIds) =>
      tasksDao.getTasksByProjectIds(projectIds);
}

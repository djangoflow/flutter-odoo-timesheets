import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/data/models/odoo_timesheet.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';
import 'package:timesheets/utils/utils.dart';

import 'sync_state.dart';

export 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  final ProjectRepository projectRepository;
  final TaskRepository taskRepository;
  final TimesheetRepository timesheetRepository;
  final OdooTaskRepository odooTaskRepository;
  final OdooTimesheetRepository odooTimesheetRepository;
  final OdooProjectRepository odooProjectRepository;
  final BackendRepository backendRepository;
  final ExternalProjectRepository externalProjectRepository;
  final ExternalTaskRepository externalTaskRepository;
  final ExternalTimesheetRepository externalTimesheetRepository;

  SyncCubit({
    required this.projectRepository,
    required this.taskRepository,
    required this.timesheetRepository,
    required this.odooTaskRepository,
    required this.odooTimesheetRepository,
    required this.odooProjectRepository,
    required this.backendRepository,
    required this.externalProjectRepository,
    required this.externalTaskRepository,
    required this.externalTimesheetRepository,
  }) : super(const SyncState.initial());

  // Handle the SyncData event
  Future<void> syncData(int backendId) async {
    try {
      emit(const SyncState.syncing());

      // Fetch projects from Odoo and insert/update in the local database
      List<OdooProject> odooProjects = await odooProjectRepository.getProjects(
        backendId: backendId,
      );
      await projectRepository.syncWithOdooProjects(
        backendId: backendId,
        odooProjects: odooProjects,
      );

      // DELETED Projects
      final orphanedExternalProjects =
          await externalProjectRepository.getOrphanedExternalProjectsForBackend(
        backendId: backendId,
        excludedExternalIds: odooProjects.map((e) => e.id).toList(),
      );

      // Fetch tasks from Odoo and insert/update in the local database
      final externalTaskIds = <int>[];

      for (final project in odooProjects) {
        externalTaskIds.addAll(project.taskIds ?? <int>[]);
      }

      final odooTasks = await odooTaskRepository.getTasksByTaskIds(
        backendId: backendId,
        taskIds: externalTaskIds,
      );
      try {
        final orphaedExternalTasks =
            await externalTaskRepository.getOrphanedExternalTasksForBackend(
                backendId: backendId, excludedIds: externalTaskIds);
        print('We are orphaed tasks :(');
        print(orphaedExternalTasks);
      } catch (e) {
        print(e);
      }

      final odooTasksWithInternalProjectIds = <OdooTask, int>{};

      for (final odooTask in odooTasks) {
        if (odooTask.projectId != null) {
          final project = await projectRepository.getProjectByExternalId(
            odooTask.projectId!,
          );
          if (project != null) {
            odooTasksWithInternalProjectIds[odooTask] = project.id;
          }
        }
      }

      await taskRepository.syncWithOdooTasks(
        odooTasksWithInternalProjectIds: odooTasksWithInternalProjectIds,
      );

      // Timesheets syncing...
      final timesheetIds = <int>[];
      for (final odooTask in odooTasks) {
        timesheetIds.addAll(odooTask.timesheetIds ?? <int>[]);
      }
      debugPrint('Total odoo timesheets ${timesheetIds.length}');
      final odooTimesheets =
          await odooTimesheetRepository.getOdooTimesheetsByIds(
        backendId: backendId,
        timesheetIds: timesheetIds,
      );

      debugPrint('Total downloaded odoo timesheets ${odooTimesheets.length}');

      final odooTimesheetsWithInternalTasks = <OdooTimesheet, Task>{};

      for (final odooTimesheet in odooTimesheets) {
        if (odooTimesheet.taskId != null) {
          final task = await taskRepository.getTaskByExternalId(
            odooTimesheet.taskId!,
          );
          if (task != null) {
            odooTimesheetsWithInternalTasks[odooTimesheet] = task;
          } else {
            debugPrint(
                'Task not found for timesheet ${odooTimesheet.id} with external id ${odooTimesheet.taskId} ');
          }
        }
      }

      await timesheetRepository.syncWithOdooTimesheets(
        odooTimesheetsWithTasksMap: odooTimesheetsWithInternalTasks,
      );

      // final odooProjectIds = odooProjects.map((e) => e.id).toList();
      // List<OdooTask> odooTasks = await odooTaskRepository.getTasksByProjectIds(
      //     backendId: backendId, projectIds: odooProjectIds);

      // Fetch timesheets from Odoo and insert/update in the local database

      emit(const SyncState.success());
    } catch (error) {
      emit(const SyncState.failure());
      rethrow;
    }
  }

  Future<void> removeData(int backendId) async {
    final externalProjects = await externalProjectRepository
        .getExternalProjectsByBackendId(backendId);
    final internalProjectIds =
        externalProjects.map((e) => e.internalId).whereType<int>().toList();

    final tasks = await taskRepository.getTasksByProjectIds(internalProjectIds);
    final taskIds = tasks.map((e) => e.id).toList();
    final externalTasks =
        await externalTaskRepository.getExternalTasksByInternalIds(taskIds);
    final timesheets =
        await timesheetRepository.getTimesheetsByTaskIds(taskIds);
    final timesheetIds = timesheets.map((e) => e.id).toList();

    final externalTimesheets = await externalTimesheetRepository
        .getExternalTimesheetsByInternalIds(timesheetIds);
    final deletableExternalTaskIds = externalTasks
        .where((e) => e.externalId != null)
        .map((e) => e.id)
        .toList();

    final deletableExternalTimesheetIds = externalTimesheets
        .where((e) => e.externalId != null)
        .map((e) => e.id)
        .toList();
    await externalTaskRepository
        .batchDeleteExternalTasksByIds(deletableExternalTaskIds);

    await externalTimesheetRepository
        .batchDeleteExternalTimesheetsByIds(deletableExternalTimesheetIds);

    debugPrint(
        'Deleted ${deletableExternalTaskIds.length} ExternalTasks, ${deletableExternalTimesheetIds.length} ExternalTimesheets');
  }
}

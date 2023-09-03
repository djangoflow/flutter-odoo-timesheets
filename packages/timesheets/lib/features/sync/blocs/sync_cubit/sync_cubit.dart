import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
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

      // // DELETED Projects
      // final orphanedExternalProjects =
      //     await externalProjectRepository.getOrphanedExternalProjectsForBackend(
      //   backendId: backendId,
      //   excludedExternalIds: odooProjects.map((e) => e.id).toList(),
      // );

      // Fetch tasks from Odoo and insert/update in the local database
      final externalTaskIds = <int>[];

      for (final project in odooProjects) {
        externalTaskIds.addAll(project.taskIds ?? <int>[]);
      }

      final odooTasks = await odooTaskRepository.getTasksByTaskIds(
        backendId: backendId,
        taskIds: externalTaskIds,
      );
      // try {
      //   final orphaedExternalTasks =
      //       await externalTaskRepository.getOrphanedExternalTasksForBackend(
      //           backendId: backendId, excludedIds: externalTaskIds);
      //   print('We are orphaed tasks :(');
      //   print(orphaedExternalTasks);
      // } catch (e) {
      //   print(e);
      // }

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

      // final orphanedExternalTimesheets = await externalTimesheetRepository
      //     .getOrphanedExternalTimesheetsForBackend(
      //   backendId: backendId,
      //   excludedExternalIds: odooTimesheets.map((e) => e.id).toList(),
      // );

      // print('We are orphaed timesheets :(');
      // print(orphanedExternalTimesheets);

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

  Future<void> uploadTimesheetToBackend(int backendId, int timesheetId) async {
    await syncStateWrapper(() async {
      await _uploadTimesheet(timesheetId, backendId);
      emit(
        const SyncState.success(),
      );
    });
  }

  Future<void> uploadTimesheetsToBackend(
      int backendId, List<Timesheet> localTimesheets) async {
    await syncStateWrapper(
      () async {
        await Future.wait(
          localTimesheets.map((e) => _uploadTimesheet(e.id, backendId)),
        );
        emit(
          const SyncState.success(),
        );
      },
    );
  }

  /// Uploads a timesheet to Odoo and updates backendId in the local database
  Future<void> _uploadTimesheet(int timesheetId, int backendId) async {
    final timesheet = await timesheetRepository.getItemById(timesheetId);
    if (timesheet == null || timesheet.taskId == null) {
      throw Exception('Timesheet with Task not found');
    }

    final taskWithProjectExternalData =
        await taskRepository.getTaskWithProjectById(timesheet.taskId!);
    if (taskWithProjectExternalData == null) {
      throw Exception('Task and Project not found');
    }

    final taskExternalId = taskWithProjectExternalData
        .taskWithExternalData.externalTask?.externalId;
    final projectExternalId = taskWithProjectExternalData
        .projectWithExternalData.externalProject?.externalId;

    if (projectExternalId == null) {
      throw Exception(
          'Project was not a synced project, need to merge with synced Project');
    }
    if (taskExternalId == null) {
      throw Exception(
          'Task was not a synced task, need to merge with synced Task');
    }

    final startTime = timesheet.startTime;
    if (startTime == null) {
      throw Exception('Timesheet was not started');
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final effetiveAdditionalDuration = Duration(seconds: timesheet.elapsedTime);
    final effectiveEndTime =
        timesheet.endTime != null && timesheet.startTime != timesheet.endTime
            ? timesheet.endTime!
            : startTime.add(effetiveAdditionalDuration);

    final timesheetExternalId = await odooTimesheetRepository.create(
      backendId: backendId,
      timesheetRequest: OdooTimesheetRequest(
        projectId: projectExternalId,
        taskId: taskExternalId,
        startTime: formatter.format(startTime),
        endTime: formatter.format(effectiveEndTime),
        unitAmount: timesheet.unitAmount ?? 0,
        name: timesheet.name,
      ),
    );
    // update timesheet with online id to mark as synced
    final externalTimesheets =
        await externalTimesheetRepository.getExternalTimesheetsByInternalIds([
      timesheetId,
    ]);
    if (externalTimesheets.isEmpty) {
      await externalTimesheetRepository.create(
        ExternalTimesheetsCompanion(
          externalId: Value(timesheetExternalId),
          internalId: Value(timesheetId),
        ),
      );
    } else {
      await externalTimesheetRepository.update(
        externalTimesheets.first.copyWith(
          externalId: Value(timesheetExternalId),
          lastSycned: Value(DateTime.now()),
        ),
      );
    }
  }

  Future syncStateWrapper(Function callback) async {
    try {
      emit(const SyncState.syncing());
      await callback.call();
    } catch (e) {
      emit(const SyncState.failure());
      rethrow;
    }
  }
}

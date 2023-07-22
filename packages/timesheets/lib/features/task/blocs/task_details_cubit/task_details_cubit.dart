import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';

export 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final TaskRepository taskRepository;
  final TimesheetRepository timesheetRepository;
  final ExternalTimesheetRepository externalTimesheetRepository;
  final OdooTimesheetRepository odooTimesheetRepository;
  final ProjectRepository projectRepository;
  final int taskId;
  TaskDetailsCubit({
    required this.taskRepository,
    required this.timesheetRepository,
    required this.externalTimesheetRepository,
    required this.odooTimesheetRepository,
    required this.projectRepository,
    required this.taskId,
  }) : super(
          TaskDetailsState.initial(),
        );

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    handleError(error);
  }

  Future<void> loadTaskDetails({bool showLoading = true}) async {
    await errorWrapper(() async {
      if (showLoading) {
        emit(TaskDetailsState.loading());
      }

      final taskWithProjectExternalData =
          await _getTaskWithProjectExternalData(taskId);

      final timesheets =
          await timesheetRepository.getPaginatedTimesheetExternalData(
        taskId: taskId,
        isEndDateNull: false,
      );
      final activeTimesheets =
          await timesheetRepository.getPaginatedTimesheetExternalData(
        taskId: taskId,
        isEndDateNull: true,
      );
      emit(
        TaskDetailsState.loaded(
          taskWithProjectExternalData: taskWithProjectExternalData,
          timesheets: timesheets,
          activeTimesheets: activeTimesheets,
        ),
      );
    });
  }

  Future<void> updateTask(Task task) async {
    await errorWrapper(() async {
      await taskRepository.update(task);
      final taskWithProjectExternalData =
          await _getTaskWithProjectExternalData(task.id);

      emit(
        TaskDetailsState.loaded(
          taskWithProjectExternalData: taskWithProjectExternalData,
          timesheets: state.timesheets,
          activeTimesheets: state.activeTimesheets,
        ),
      );
    });
  }

  Future<void> updateProject(Project project) async {
    await errorWrapper(() async {
      await projectRepository.update(project);
      final updatedProject = await projectRepository.getItemById(project.id);
      if (updatedProject == null) {
        throw Exception('Project not found');
      }
      emit(
        TaskDetailsState.loaded(
          taskWithProjectExternalData:
              state.taskWithProjectExternalData!.copyWith(
            projectWithExternalData: state
                .taskWithProjectExternalData!.projectWithExternalData
                .copyWith(
              project: updatedProject,
            ),
          ),
          timesheets: state.timesheets,
          activeTimesheets: state.activeTimesheets,
        ),
      );
    });
  }

  Future<void> updateTimesheet(Timesheet timesheet) async {
    await errorWrapper(() async {
      if (timesheet.endTime != null) {
        throw Exception('Timesheet has already ended');
      }
      await timesheetRepository.update(timesheet);
      final updatedTimesheetWithExternalData =
          await timesheetRepository.getTimesheetExternalDataById(timesheet.id);
      if (updatedTimesheetWithExternalData == null) {
        throw Exception('Timesheet not found');
      }

      emit(state.copyWith(
        timesheets: [
          for (final timesheetExternalData in state.timesheets)
            if (timesheetExternalData.timesheet.id ==
                updatedTimesheetWithExternalData.timesheet.id)
              updatedTimesheetWithExternalData
            else
              timesheetExternalData,
        ],
      ));
    });
  }

  Future<void> stopWorkingOnTimesheet(int timesheetId) async {
    await errorWrapper(() async {
      await _stopWorkinOnTimesheet(timesheetId);
      final updatedTimesheetWithExternalData =
          await timesheetRepository.getTimesheetExternalDataById(timesheetId);
      if (updatedTimesheetWithExternalData == null) {
        throw Exception('Timesheet not found');
      }

      emit(
        state.copyWith(
          timesheets: [updatedTimesheetWithExternalData, ...state.timesheets],
          activeTimesheets: [
            for (final timesheetExternalData in state.activeTimesheets)
              if (timesheetExternalData.timesheet.id !=
                  updatedTimesheetWithExternalData.timesheet.id)
                timesheetExternalData,
          ],
        ),
      );
    });
  }

  Future<void> _stopWorkinOnTimesheet(int timesheetId) async {
    final timesheet = await timesheetRepository.getItemById(timesheetId);
    if (timesheet == null) {
      throw Exception('Timesheet not found');
    }

    if (timesheet.startTime == null) {
      throw Exception('Timesheet has not started yet');
    }
    if (timesheet.endTime != null) {
      throw Exception('Timesheet has already ended');
    }
    await timesheetRepository.update(
      timesheet.copyWith(
        endTime: Value(
          timesheet.startTime?.add(
            Duration(seconds: (timesheet.unitAmount?.toInt() ?? 0) * 3600),
          ),
        ),
      ),
    );
  }

  Future<void> deleteTask() async {
    await errorWrapper(() async {
      emit(TaskDetailsState.loading());
      final project =
          state.taskWithProjectExternalData?.projectWithExternalData.project;
      if (project == null) {
        throw Exception('Project not found');
      }
      await projectRepository.delete(project);
      emit(
        TaskDetailsState.initial(),
      );
    });
  }

  Future<void> _syncLocalTimesheetsToOdoo() async {
    // find out the external id of the project
    final taskWithProjectExternalData = state.taskWithProjectExternalData;
    if (taskWithProjectExternalData == null) {
      throw Exception('Task or Project not found');
    }
    final externalProject =
        taskWithProjectExternalData.projectWithExternalData.externalProject;
    final externalProjectId = externalProject?.externalId;
    final externalProjectBackendId = externalProject?.backendId;
    if (externalProject == null ||
        externalProjectId == null ||
        externalProjectBackendId == null) {
      throw Exception('Project is not synced with any backends');
    }

    // find out the external id of the task
    final externalTask =
        taskWithProjectExternalData.taskWithExternalData.externalTask;
    final externalTaskId = externalTask?.externalId;
    if (externalTask == null || externalTaskId == null) {
      throw Exception('Task is not synced with any backends');
    }
  }

  Future<void> _syncFromOdooTimesheets() async {
    // final taskWithProjectExternalData = state.taskWithProjectExternalData;
    // if (taskWithProjectExternalData == null) {
    //   throw Exception('Task or Project not found');
    // }
    // final task = taskWithProjectExternalData.task;
    // final project = taskWithProjectExternalData.project;

    // final alreadySyncedTimesheets = state.timesheets
    //     .where((timesheet) => timesheet.onlineId != null)
    //     .toList();
    // final odooTimesheetIds =
    //     alreadySyncedTimesheets.map((e) => e.onlineId as int).toList();

    // final odooTimesheets =
    //     await odooTimesheetRepository.getOdooTimesheetsByIds(odooTimesheetIds);

    // // match alreadySycnedTimesheets with odooTimesheets and update the objects in alreadySycnedTimesheets from the odooTimesheets
    // for (final timesheet in alreadySyncedTimesheets) {
    //   final odooTimesheet = odooTimesheets.firstWhereOrNull(
    //     (odooTimesheet) => odooTimesheet.id == timesheet.onlineId,
    //   );
    //   if (odooTimesheet != null) {
    //     // TODO create new task if task or project's online has been changed
    //     await timesheetRepository.updateTimesheet(
    //       timesheet.copyWith(
    //         startTime: odooTimesheet.startTime,
    //         endTime: odooTimesheet.endTime,
    //         totalSpentSeconds: (odooTimesheet.unitAmount * 3600).toInt(),
    //       ),
    //     );
    //   }
    // }
  }

  Future<void> syncAllTimesheets(int backendId) async {
    // await errorWrapper(() async {
    //   final taskWithProjectExternalData = state.taskWithProjectExternalData;
    //   if (taskWithProjectExternalData == null) {
    //     throw Exception('Task or Project not found');
    //   }
    //   emit(TaskDetailsState.syncing(
    //     taskWithProjectExternalData: state.taskWithProjectExternalData!,
    //     timesheets: state.timesheets,
    //   ));
    //   await _syncLocalTimesheetsToOdoo(backendId);

    //   await _syncFromOdooTimesheets();

    //   final timesheets = await timesheetRepository.getTimesheets(
    //     taskWithProjectExternalData.task.id,
    //   );
    //   emit(
    //     TaskDetailsState.loaded(
    //       taskWithProjectExternalData: taskWithProjectExternalData,
    //       timesheets: timesheets,
    //     ),
    //   );
    // });
  }

  /// Syncs a timesheet to Odoo and updates onlineId in the local database
  Future<void> _syncTimesheet(int timesheetId, int backendId) async {
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

    if (taskExternalId == null || projectExternalId == null) {
      throw Exception('Task or Project not found');
    }

    final startTime = timesheet.startTime;
    if (startTime == null) {
      throw Exception('Timesheet was not started');
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final timesheetExternalId = await odooTimesheetRepository.create(
      backendId: backendId,
      timesheetRequest: OdooTimesheetRequest(
        projectId: projectExternalId,
        taskId: taskExternalId,
        startTime: formatter.format(startTime),
        endTime: formatter.format(
          startTime.add(
            Duration(seconds: (timesheet.unitAmount?.toInt() ?? 0) * 3600),
          ),
        ),
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

  Future<void> syncTimesheet(int timesheetId, int backendId) async {
    await errorWrapper(() async {
      emit(
        TaskDetailsState.syncing(
          taskWithProjectExternalData: state.taskWithProjectExternalData!,
          timesheets: state.timesheets,
          activeTimesheets: state.activeTimesheets,
        ),
      );
      await _syncTimesheet(timesheetId, backendId);
      final updatedTimesheetWithExternal =
          await timesheetRepository.getTimesheetExternalDataById(timesheetId);

      if (updatedTimesheetWithExternal == null) {
        throw Exception('Updated Timesheet not found');
      }
      final taskId = updatedTimesheetWithExternal.timesheet.taskId;
      if (taskId == null) {
        throw Exception('Task not found');
      }

      await loadTaskDetails(
        showLoading: false,
      );
    });
  }

  Future errorWrapper(Function callback) async {
    try {
      await callback.call();
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  void handleError(Object error) {
    emit(
      TaskDetailsState.error(
        taskWithProjectExternalData: state.taskWithProjectExternalData,
        timesheets: state.timesheets,
        activeTimesheets: state.activeTimesheets,
        error: error,
      ),
    );
  }

  Future<TaskWithProjectExternalData> _getTaskWithProjectExternalData(
      int taskId) async {
    final taskWithProjectExternalData =
        await taskRepository.getTaskWithProjectById(taskId);
    if (taskWithProjectExternalData == null) {
      throw Exception('Task with id $taskId not found');
    }

    return taskWithProjectExternalData;
  }
}

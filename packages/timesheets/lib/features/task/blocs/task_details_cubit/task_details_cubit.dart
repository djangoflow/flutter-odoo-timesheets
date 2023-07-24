import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';
import 'package:timesheets/utils/utils.dart';

export 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final TaskRepository taskRepository;
  final TimesheetRepository timesheetRepository;
  final ExternalTimesheetRepository externalTimesheetRepository;
  final OdooTimesheetRepository odooTimesheetRepository;
  final ProjectRepository projectRepository;
  int taskId;
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

  set taskIdValue(int value) {
    taskId = value;
  }

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
        activeTimesheets: [
          for (final timesheetExternalData in state.activeTimesheets)
            if (timesheetExternalData.timesheet.id ==
                updatedTimesheetWithExternalData.timesheet.id)
              updatedTimesheetWithExternalData
            else
              timesheetExternalData,
        ],
      ));
    });
  }

  Future<Timesheet?> getTimesheetById(int timesheetId) =>
      timesheetRepository.getItemById(timesheetId);

  Future<TaskWithProjectExternalData> getTaskWithProjectExternalDataByTaskId(
          int taskId) =>
      _getTaskWithProjectExternalData(taskId);

  Future<void> stopWorkingOnTimesheet(int timesheetId) async {
    await errorWrapper(() async {
      await _stopWorkinOnTimesheet(timesheetId);
      final updatedTimesheetWithExternalData =
          await timesheetRepository.getTimesheetExternalDataById(timesheetId);
      if (updatedTimesheetWithExternalData == null) {
        throw Exception('Timesheet not found');
      }
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
          timesheet.calculatedEndDate,
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

  Future<void> _syncLocalTimesheetsToOdoo(int backendId) async {
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

    final localTimesheetsWithExternalData = state.timesheets
        .where((element) => element.externalTimesheet == null)
        .toList();

    // create timesheets on Odoo
    for (final timesheetWithExternalData in localTimesheetsWithExternalData) {
      await _syncTimesheet(timesheetWithExternalData.timesheet.id, backendId);
    }
  }

  Future<void> syncAllTimesheets(int backendId) async {
    await errorWrapper(() async {
      final taskWithProjectExternalData = state.taskWithProjectExternalData;
      if (taskWithProjectExternalData == null) {
        throw Exception('Task or Project not found');
      }
      emit(TaskDetailsState.syncing(
        taskWithProjectExternalData: state.taskWithProjectExternalData!,
        timesheets: state.timesheets,
        activeTimesheets: state.activeTimesheets,
      ));
      await _syncLocalTimesheetsToOdoo(backendId);

      final timesheets =
          await timesheetRepository.getPaginatedTimesheetExternalData(
        taskId: taskId,
        isEndDateNull: false,
      );
      emit(
        TaskDetailsState.loaded(
          taskWithProjectExternalData: taskWithProjectExternalData,
          timesheets: timesheets,
          activeTimesheets: state.activeTimesheets,
        ),
      );
    });
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

  Future<void> updateTimesheetsProjectAndTaskIds({
    required int oldProjectId,
    required int oldTaskId,
    required int updatedProjectId,
    required int updatedTaskId,
  }) =>
      errorWrapper(() async {
        timesheetRepository.updateTimesheetsProjectAndTaskIds(
          oldProjectId: oldProjectId,
          oldTaskId: oldTaskId,
          updatedProjectId: updatedProjectId,
          updatedTaskId: updatedTaskId,
        );
      });

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

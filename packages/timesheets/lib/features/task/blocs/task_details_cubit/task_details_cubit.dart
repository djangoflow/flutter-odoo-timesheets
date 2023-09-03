import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';
import 'package:timesheets/utils/utils.dart';

export 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final TaskRepository taskRepository;
  final TimesheetRepository timesheetRepository;
  final ExternalTimesheetRepository externalTimesheetRepository;
  final ExternalProjectRepository externalProjectRepository;
  final ExternalTaskRepository externalTaskRepository;

  final ProjectRepository projectRepository;
  int taskId;
  TaskDetailsCubit({
    required this.taskRepository,
    required this.timesheetRepository,
    required this.externalTimesheetRepository,
    required this.projectRepository,
    required this.taskId,
    required this.externalProjectRepository,
    required this.externalTaskRepository,
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
      final task = state.taskWithProjectExternalData?.taskWithExternalData.task;
      if (task == null) {
        throw Exception('Task not found');
      }
      await taskRepository.delete(task);
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

  Future<void> deleteExternalProject() async {
    await errorWrapper(() async {
      final externalProject = state
          .taskWithProjectExternalData?.projectWithExternalData.externalProject;
      if (externalProject == null) {
        throw Exception('External project not found');
      }
      await externalProjectRepository.delete(externalProject);
    });
  }

  Future<void> deleteExternalTask() async {
    await errorWrapper(() async {
      final externalTask =
          state.taskWithProjectExternalData?.taskWithExternalData.externalTask;
      if (externalTask == null) {
        throw Exception('External task not found');
      }

      await externalTaskRepository.delete(externalTask);
    });
  }

  Future<void> deleteProject() async {
    await errorWrapper(() async {
      final project =
          state.taskWithProjectExternalData?.projectWithExternalData.project;
      if (project == null) {
        throw Exception('Project not found');
      }
      await projectRepository.delete(project);
    });
  }

  Future<void> deleteExternalTimesheets() async {
    await errorWrapper(() async {
      final externalTimesheets = state.timesheets
          .where((element) => element.externalTimesheet != null)
          .toList();
      for (final externalTimesheet in externalTimesheets) {
        await externalTimesheetRepository
            .delete(externalTimesheet.externalTimesheet!);
      }
    });
  }
}

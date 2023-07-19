import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';

export 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final TaskRepository taskRepository;
  final TimesheetRepository timesheetRepository;
  final OdooTimesheetRepository odooTimesheetRepository;
  final ProjectRepository projectRepository;

  TaskDetailsCubit({
    required this.taskRepository,
    required this.timesheetRepository,
    required this.odooTimesheetRepository,
    required this.projectRepository,
  }) : super(
          TaskDetailsState.initial(),
        );

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    handleError(error);
  }

  Future<void> loadTaskDetails(int taskId) async {
    await errorWrapper(() async {
      emit(TaskDetailsState.loading());
      final taskWithProjectExternalData =
          await _getTaskWithProjectExternalData(taskId);

      final timesheets = await timesheetRepository.getItemsByTaskId(taskId);
      emit(
        TaskDetailsState.loaded(
          taskWithProjectExternalData: taskWithProjectExternalData,
          timesheets: timesheets,
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
        ),
      );
    });
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
    // final timesheet = await timesheetRepository.getTimesheetById(timesheetId);
    // if (timesheet == null) {
    //   throw Exception('Timesheet not found');
    // }

    // final taskWithProjectExternalData =
    //     await taskRepository.getTaskWithProjectById(timesheet.taskId);
    // if (taskWithProjectExternalData == null) {
    //   throw Exception('Task and Project not found');
    // }

    // final taskOnlineId = taskWithProjectExternalData.task.onlineId;
    // final projectOnlineId = taskWithProjectExternalData.project.onlineId;

    // if (taskOnlineId == null || projectOnlineId == null) {
    //   throw Exception('Task or Project not found');
    // }

    // final startTime = timesheet.startTime;
    // final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    // final timesheetOnlineId = await odooTimesheetRepository.create(
    //   OdooTimesheetRequest(
    //     projectId: projectOnlineId,
    //     taskId: taskOnlineId,
    //     startTime: formatter.format(startTime),
    //     endTime: formatter.format(
    //       startTime.add(
    //         Duration(seconds: timesheet.totalSpentSeconds),
    //       ),
    //     ),
    //     unitAmount: double.parse(
    //         (timesheet.totalSpentSeconds / 3600).toStringAsFixed(2)),
    //     name: taskWithProjectExternalData.task.description,
    //   ),
    // );
    // // update timesheet with online id to mark as synced
    // await timesheetRepository.updateTimesheet(
    //   timesheet.copyWith(
    //     onlineId: Value(timesheetOnlineId),
    //   ),
    // );

    // // update task backend to mark as synced, all the timesheets are under one TaskBackend
    // final taskId = taskWithProjectExternalData.task.id;
    // final taskBackend =
    //     await taskBackendRepository.getTaskBackendByTaskId(taskId);
    // if (taskBackend == null) {
    //   await taskBackendRepository.createTaskBackend(
    //     TaskBackendsCompanion(
    //       taskId: Value(taskId),
    //       backendId: Value(backendId),
    //       lastSynced: Value(DateTime.now()),
    //     ),
    //   );
    // } else {
    //   await taskBackendRepository.updateTaskBackend(
    //     taskBackend.copyWith(
    //       lastSynced: Value(DateTime.now()),
    //     ),
    //   );
    // }
  }

  Future<void> createTimesheet(
      {required TimesheetsCompanion timesheetsCompanion,
      int? backendId}) async {
    await errorWrapper(() async {
      final timesheetId = await timesheetRepository.create(timesheetsCompanion);
      final timesheet = await timesheetRepository.getItemById(timesheetId);
      if (timesheet == null) {
        throw Exception('Timesheet not found');
      }
      emit(TaskDetailsState.loaded(
          taskWithProjectExternalData: state.taskWithProjectExternalData!,
          timesheets: [timesheet, ...state.timesheets]));
      if (backendId != null) {
        emit(
          TaskDetailsState.syncing(
            taskWithProjectExternalData: state.taskWithProjectExternalData!,
            timesheets: state.timesheets,
          ),
        );
        await _syncTimesheet(timesheetId, backendId);
        final updatedTimesheet =
            await timesheetRepository.getItemById(timesheetId);
        if (updatedTimesheet == null) {
          throw Exception('Updated Timesheet not found');
        }
        emit(
          TaskDetailsState.loaded(
            taskWithProjectExternalData: state.taskWithProjectExternalData!,
            timesheets: [
              for (final timesheet in state.timesheets)
                if (timesheet.id == timesheetId)
                  updatedTimesheet
                else
                  timesheet,
            ],
          ),
        );
      }
    });
  }

  Future<void> syncTimesheet(int timesheetId, int backendId) async {
    await errorWrapper(() async {
      emit(
        TaskDetailsState.syncing(
          taskWithProjectExternalData: state.taskWithProjectExternalData!,
          timesheets: state.timesheets,
        ),
      );
      await _syncTimesheet(timesheetId, backendId);
      final updatedTimesheet =
          await timesheetRepository.getItemById(timesheetId);
      if (updatedTimesheet == null) {
        throw Exception('Updated Timesheet not found');
      }
      emit(
        TaskDetailsState.loaded(
          taskWithProjectExternalData: state.taskWithProjectExternalData!,
          timesheets: [
            for (final timesheet in state.timesheets)
              if (timesheet.id == timesheetId) updatedTimesheet else timesheet,
          ],
        ),
      );
    });
  }

  Future<void> resetTask(Task task) async {
    // TODO Need to create a new timesheet for this task which will be have initial status
    // await errorWrapper(() async {
    //   await taskRepository.resetTask(task);
    //   final taskWithProjectExternalData =
    //       await taskRepository.getTaskWithProjectById(task.id);

    //   if (taskWithProjectExternalData == null) {
    //     throw Exception('Task not found');
    //   }

    //   emit(
    //     TaskDetailsState.loaded(
    //       taskWithProjectExternalData: taskWithProjectExternalData,
    //       timesheets: state.timesheets,
    //     ),
    //   );
    // });
  }

  Future errorWrapper(Function callback) async {
    try {
      await callback.call();
    } catch (e) {
      handleError(e);
      print('rethrowing');
      rethrow;
    }
  }

  void handleError(Object error) {
    emit(
      TaskDetailsState.error(
        taskWithProjectExternalData: state.taskWithProjectExternalData,
        timesheets: state.timesheets,
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

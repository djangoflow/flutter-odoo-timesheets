import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

export 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final TasksRepository tasksRepository;
  final TimesheetsRepository timesheetsRepository;
  final OdooTimesheetRepository odooTimesheetRepository;
  final TaskBackendRepository taskBackendRepository;

  TaskDetailsCubit({
    required this.tasksRepository,
    required this.timesheetsRepository,
    required this.odooTimesheetRepository,
    required this.taskBackendRepository,
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
      final taskWithProject =
          await tasksRepository.getTaskWithProjectById(taskId);
      if (taskWithProject == null) {
        throw Exception('Task with id $taskId not found');
      }

      final timesheets = await timesheetsRepository.getTimesheets(taskId);
      emit(
        TaskDetailsState.loaded(
          taskWithProject: taskWithProject,
          timesheets: timesheets,
        ),
      );
    });
  }

  Future<void> updateTask(Task task) async {
    await errorWrapper(() async {
      await tasksRepository.updateTaskWithProject(
        task: task,
      );
      emit(
        TaskDetailsState.loaded(
          taskWithProject: state.taskWithProject!.copyWith(task: task),
          timesheets: state.timesheets,
        ),
      );
    });
  }

  Future<void> updateProject(Project project) async {
    await errorWrapper(() async {
      await tasksRepository.updateTaskWithProject(
        project: project,
      );
      emit(
        TaskDetailsState.loaded(
          taskWithProject: state.taskWithProject!.copyWith(project: project),
          timesheets: state.timesheets,
        ),
      );
    });
  }

  Future<void> deleteTask() async {
    await errorWrapper(() async {
      emit(TaskDetailsState.loading());
      await tasksRepository.deleteTask(state.taskWithProject!.task);
      emit(
        TaskDetailsState.initial(),
      );
    });
  }

  Future<void> _syncLocalTimesheetsToOdoo(int backendId) async {
    final taskWithProject = state.taskWithProject;
    if (taskWithProject == null) {
      throw Exception('Task not found');
    }
    final taskId = taskWithProject.task.id;

    TaskBackend? taskBackend =
        await taskBackendRepository.getTaskBackendByTaskId(taskId);
    if (taskBackend == null) {
      await taskBackendRepository.createTaskBackend(
        TaskBackendsCompanion(
          taskId: Value(taskId),
          backendId: Value(backendId),
        ),
      );
      taskBackend = await taskBackendRepository.getTaskBackendByTaskId(taskId);
    }

    if (taskBackend == null) {
      throw Exception('Task backend not found');
    }

    final unsyncedTimesheets = state.timesheets.unsyncedTimesheets;
    if (unsyncedTimesheets.isEmpty) {
      return;
    }

    for (final timesheet in unsyncedTimesheets) {
      await _syncTimesheet(timesheet.id, backendId);
    }
  }

  Future<void> _syncFromOdooTimesheets() async {
    final taskWithProject = state.taskWithProject;
    if (taskWithProject == null) {
      throw Exception('Task or Project not found');
    }
    final task = taskWithProject.task;
    final project = taskWithProject.project;

    final alreadySyncedTimesheets = state.timesheets
        .where((timesheet) => timesheet.onlineId != null)
        .toList();
    final odooTimesheetIds =
        alreadySyncedTimesheets.map((e) => e.onlineId as int).toList();

    final odooTimesheets =
        await odooTimesheetRepository.getOdooTimesheetsByIds(odooTimesheetIds);

    // match alreadySycnedTimesheets with odooTimesheets and update the objects in alreadySycnedTimesheets from the odooTimesheets
    for (final timesheet in alreadySyncedTimesheets) {
      final odooTimesheet = odooTimesheets.firstWhereOrNull(
        (odooTimesheet) => odooTimesheet.id == timesheet.onlineId,
      );
      if (odooTimesheet != null) {
        // TODO create new task if task or project's online has been changed
        await timesheetsRepository.updateTimesheet(
          timesheet.copyWith(
            startTime: odooTimesheet.startTime,
            endTime: odooTimesheet.endTime,
            totalSpentSeconds: (odooTimesheet.unitAmount * 3600).toInt(),
          ),
        );
      }
    }
  }

  Future<void> syncAllTimesheets(int backendId) async {
    await errorWrapper(() async {
      final taskWithProject = state.taskWithProject;
      if (taskWithProject == null) {
        throw Exception('Task or Project not found');
      }
      emit(TaskDetailsState.syncing(
        taskWithProject: state.taskWithProject!,
        timesheets: state.timesheets,
      ));
      await Future.delayed(Duration(seconds: 3));
      await _syncLocalTimesheetsToOdoo(backendId);

      await _syncFromOdooTimesheets();

      final timesheets = await timesheetsRepository.getTimesheets(
        taskWithProject.task.id,
      );
      emit(
        TaskDetailsState.loaded(
          taskWithProject: taskWithProject,
          timesheets: timesheets,
        ),
      );
    });
  }

  /// Syncs a timesheet to Odoo and updates onlineId in the local database
  Future<void> _syncTimesheet(int timesheetId, int backendId) async {
    final timesheet = await timesheetsRepository.getTimesheetById(timesheetId);
    if (timesheet == null) {
      throw Exception('Timesheet not found');
    }

    final taskWithProject =
        await tasksRepository.getTaskWithProjectById(timesheet.taskId);
    if (taskWithProject == null) {
      throw Exception('Task and Project not found');
    }

    final taskOnlineId = taskWithProject.task.onlineId;
    final projectOnlineId = taskWithProject.project.onlineId;

    if (taskOnlineId == null || projectOnlineId == null) {
      throw Exception('Task or Project not found');
    }

    final startTime = timesheet.startTime;
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final timesheetOnlineId = await odooTimesheetRepository.create(
      OdooTimesheetRequest(
        projectId: projectOnlineId,
        taskId: taskOnlineId,
        startTime: formatter.format(startTime),
        endTime: formatter.format(
          startTime.add(
            Duration(seconds: timesheet.totalSpentSeconds),
          ),
        ),
        unitAmount: double.parse(
            (timesheet.totalSpentSeconds / 3600).toStringAsFixed(2)),
        name: taskWithProject.task.description,
      ),
    );
    // update timesheet with online id to mark as synced
    await timesheetsRepository.updateTimesheet(
      timesheet.copyWith(
        onlineId: Value(timesheetOnlineId),
      ),
    );

    // update task backend to mark as synced, all the timesheets are under one TaskBackend
    final taskId = taskWithProject.task.id;
    final taskBackend =
        await taskBackendRepository.getTaskBackendByTaskId(taskId);
    if (taskBackend == null) {
      await taskBackendRepository.createTaskBackend(
        TaskBackendsCompanion(
          taskId: Value(taskId),
          backendId: Value(backendId),
          lastSynced: Value(DateTime.now()),
        ),
      );
    } else {
      await taskBackendRepository.updateTaskBackend(
        taskBackend.copyWith(
          lastSynced: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> createTimesheet(
      {required TimesheetsCompanion timesheetsCompanion,
      int? backendId}) async {
    await errorWrapper(() async {
      final timesheetId =
          await timesheetsRepository.createTimeSheet(timesheetsCompanion);
      final timesheet =
          await timesheetsRepository.getTimesheetById(timesheetId);
      if (timesheet == null) {
        throw Exception('Timesheet not found');
      }
      emit(TaskDetailsState.loaded(
          taskWithProject: state.taskWithProject!,
          timesheets: [timesheet, ...state.timesheets]));
      if (backendId != null) {
        emit(
          TaskDetailsState.syncing(
            taskWithProject: state.taskWithProject!,
            timesheets: state.timesheets,
          ),
        );
        await _syncTimesheet(timesheetId, backendId);
        final updatedTimesheet =
            await timesheetsRepository.getTimesheetById(timesheetId);
        if (updatedTimesheet == null) {
          throw Exception('Updated Timesheet not found');
        }
        emit(
          TaskDetailsState.loaded(
            taskWithProject: state.taskWithProject!,
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
          taskWithProject: state.taskWithProject!,
          timesheets: state.timesheets,
        ),
      );
      await _syncTimesheet(timesheetId, backendId);
      final updatedTimesheet =
          await timesheetsRepository.getTimesheetById(timesheetId);
      if (updatedTimesheet == null) {
        throw Exception('Updated Timesheet not found');
      }
      emit(
        TaskDetailsState.loaded(
          taskWithProject: state.taskWithProject!,
          timesheets: [
            for (final timesheet in state.timesheets)
              if (timesheet.id == timesheetId) updatedTimesheet else timesheet,
          ],
        ),
      );
    });
  }

  Future<void> resetTask(Task task) async {
    await errorWrapper(() async {
      await tasksRepository.resetTask(task);
      final taskWithProject =
          await tasksRepository.getTaskWithProjectById(task.id);

      if (taskWithProject == null) {
        throw Exception('Task not found');
      }

      emit(
        TaskDetailsState.loaded(
          taskWithProject: taskWithProject,
          timesheets: state.timesheets,
        ),
      );
    });
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
        taskWithProject: state.taskWithProject,
        timesheets: state.timesheets,
        error: error,
      ),
    );
  }
}

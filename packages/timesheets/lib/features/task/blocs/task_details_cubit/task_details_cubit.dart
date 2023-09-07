import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/task/blocs/task_data_cubit/task_data_filter.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_data_cubit/timesheet_data_filter.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

export 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final TaskWithProjectRepository taskWithProjectRepository;
  final TimesheetRepository timesheetRepository;

  int taskId;
  TaskDetailsCubit({
    required this.taskWithProjectRepository,
    required this.timesheetRepository,
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

      final taskWithProject = await taskWithProjectRepository.getItemById(
        TaskDataFilter(id: taskId),
      );

      final timesheets = await timesheetRepository.getPaginatedItems(
        TimesheetPaginationFilter(
          taskId: taskId,
          isEndDateNull: false,
        ),
      );
      final activeTimesheets = await timesheetRepository.getPaginatedItems(
        TimesheetPaginationFilter(
          taskId: taskId,
          isEndDateNull: true,
        ),
      );
      emit(
        TaskDetailsState.loaded(
          taskWithProject: taskWithProject,
          timesheets: timesheets,
          activeTimesheets: activeTimesheets,
        ),
      );
    });
  }

  Future<void> updateTask(Task task) async {
    await errorWrapper(() async {
      if (state.taskWithProject == null) {
        throw Exception('Task and Project data was not loaded');
      }
      final updatedTaskWithProject = await taskWithProjectRepository.updateItem(
        state.taskWithProject!.copyWith(task: task),
      );

      emit(
        TaskDetailsState.loaded(
          taskWithProject: updatedTaskWithProject,
          timesheets: state.timesheets,
          activeTimesheets: state.activeTimesheets,
        ),
      );
    });
  }

  Future<void> updateTimesheet(Timesheet timesheet) async {
    await errorWrapper(() async {
      final updatedTimesheet = await timesheetRepository.updateItem(timesheet);

      emit(
        state.copyWith(
          timesheets: _getTimesheetsWithUpdatedTimesheet(
              state.timesheets, updatedTimesheet),
          activeTimesheets: _getTimesheetsWithUpdatedTimesheet(
              state.activeTimesheets, updatedTimesheet),
        ),
      );
    });
  }

  List<Timesheet> _getTimesheetsWithUpdatedTimesheet(
    List<Timesheet> timesheets,
    Timesheet updatedTimesheet,
  ) =>
      [
        for (final timesheet in timesheets)
          if (timesheet.id == updatedTimesheet.id)
            updatedTimesheet
          else
            timesheet,
      ];

  Future<void> stopWorkingOnTimesheet(int timesheetId) async {
    await errorWrapper(() async {
      await _stopWorkinOnTimesheet(timesheetId);
      final updatedTimesheetWithExternalData = await timesheetRepository
          .getItemById(TimesheetDataFilter(id: timesheetId));
    });
  }

  Future<void> _stopWorkinOnTimesheet(int timesheetId) async {
    final timesheet = await timesheetRepository
        .getItemById(TimesheetDataFilter(id: timesheetId));

    if (timesheet.startTime == null) {
      throw Exception('Timesheet has not started yet');
    }

    await timesheetRepository.updateItem(
      timesheet.copyWith(
        endTime: timesheet.calculatedEndDate,
      ),
    );
  }

  Future<void> deleteTask() async {
    await errorWrapper(() async {
      emit(TaskDetailsState.loading());
      final task = state.taskWithProject?.task;
      if (task == null || task.id == null) {
        throw Exception('Task not found');
      }
      await taskWithProjectRepository.deleteItem(task.id!);
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
        taskWithProject: state.taskWithProject,
        timesheets: state.timesheets,
        activeTimesheets: state.activeTimesheets,
        error: error,
      ),
    );
  }
}

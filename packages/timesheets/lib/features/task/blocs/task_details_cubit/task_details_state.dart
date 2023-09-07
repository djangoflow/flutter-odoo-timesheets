import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

part 'task_details_state.freezed.dart';

@freezed
class TaskDetailsState with _$TaskDetailsState {
  const factory TaskDetailsState({
    TaskWithProject? taskWithProject,
    required List<Timesheet> timesheets,

    /// This is the list of timesheets that are not stopped yet
    required List<Timesheet> activeTimesheets,
    required bool isLoading,
    Object? error,
  }) = _TaskDetailsState;

  factory TaskDetailsState.initial() => const TaskDetailsState(
        taskWithProject: null,
        timesheets: [],
        activeTimesheets: [],
        isLoading: false,
        error: null,
      );

  factory TaskDetailsState.loading() => const TaskDetailsState(
        taskWithProject: null,
        timesheets: [],
        activeTimesheets: [],
        isLoading: true,
        error: null,
      );

  factory TaskDetailsState.syncing({
    required TaskWithProject taskWithProject,
    required List<Timesheet> timesheets,
    required List<Timesheet> activeTimesheets,
  }) =>
      TaskDetailsState(
        taskWithProject: taskWithProject,
        timesheets: timesheets,
        activeTimesheets: activeTimesheets,
        isLoading: false,
        error: null,
      );

  factory TaskDetailsState.loaded({
    required TaskWithProject taskWithProject,
    required List<Timesheet> timesheets,
    required List<Timesheet> activeTimesheets,
  }) =>
      TaskDetailsState(
        taskWithProject: taskWithProject,
        timesheets: timesheets,
        activeTimesheets: activeTimesheets,
        isLoading: false,
        error: null,
      );

  factory TaskDetailsState.error({
    TaskWithProject? taskWithProject,
    required List<Timesheet> timesheets,
    required List<Timesheet> activeTimesheets,
    required Object error,
  }) =>
      TaskDetailsState(
        taskWithProject: taskWithProject,
        timesheets: timesheets,
        activeTimesheets: activeTimesheets,
        isLoading: false,
        error: error,
      );
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';

part 'task_details_state.freezed.dart';

@freezed
class TaskDetailsState with _$TaskDetailsState {
  const factory TaskDetailsState({
    TaskWithProject? taskWithProject,
    required List<Timesheet> timesheets,
    required bool isLoading,
    required bool isSyncing,
    Object? error,
  }) = _TaskDetailsState;

  factory TaskDetailsState.initial() => const TaskDetailsState(
        taskWithProject: null,
        timesheets: [],
        isLoading: false,
        isSyncing: false,
        error: null,
      );

  factory TaskDetailsState.loading() => const TaskDetailsState(
        taskWithProject: null,
        timesheets: [],
        isLoading: true,
        isSyncing: false,
        error: null,
      );

  factory TaskDetailsState.syncing({
    required TaskWithProject taskWithProject,
    required List<Timesheet> timesheets,
  }) =>
      TaskDetailsState(
        taskWithProject: taskWithProject,
        timesheets: timesheets,
        isLoading: false,
        isSyncing: true,
        error: null,
      );

  factory TaskDetailsState.loaded({
    required TaskWithProject taskWithProject,
    required List<Timesheet> timesheets,
  }) =>
      TaskDetailsState(
        taskWithProject: taskWithProject,
        timesheets: timesheets,
        isLoading: false,
        isSyncing: false,
        error: null,
      );

  factory TaskDetailsState.error({
    TaskWithProject? taskWithProject,
    required List<Timesheet> timesheets,
    required Object error,
  }) =>
      TaskDetailsState(
        taskWithProject: taskWithProject,
        timesheets: timesheets,
        isLoading: false,
        isSyncing: false,
        error: error,
      );
}

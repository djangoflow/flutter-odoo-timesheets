import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/task/data/models/task_with_project_external_data.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

part 'task_details_state.freezed.dart';

@freezed
class TaskDetailsState with _$TaskDetailsState {
  const factory TaskDetailsState({
    TaskWithProjectExternalData? taskWithProjectExternalData,
    required List<TimesheetExternalData> timesheets,

    /// This is the list of timesheets that are not stopped yet
    required List<TimesheetExternalData> activeTimesheets,
    required bool isLoading,
    required bool isSyncing,
    Object? error,
  }) = _TaskDetailsState;

  factory TaskDetailsState.initial() => const TaskDetailsState(
        taskWithProjectExternalData: null,
        timesheets: [],
        activeTimesheets: [],
        isLoading: false,
        isSyncing: false,
        error: null,
      );

  factory TaskDetailsState.loading() => const TaskDetailsState(
        taskWithProjectExternalData: null,
        timesheets: [],
        activeTimesheets: [],
        isLoading: true,
        isSyncing: false,
        error: null,
      );

  factory TaskDetailsState.syncing({
    required TaskWithProjectExternalData taskWithProjectExternalData,
    required List<TimesheetExternalData> timesheets,
    required List<TimesheetExternalData> activeTimesheets,
  }) =>
      TaskDetailsState(
        taskWithProjectExternalData: taskWithProjectExternalData,
        timesheets: timesheets,
        activeTimesheets: activeTimesheets,
        isLoading: false,
        isSyncing: true,
        error: null,
      );

  factory TaskDetailsState.loaded({
    required TaskWithProjectExternalData taskWithProjectExternalData,
    required List<TimesheetExternalData> timesheets,
    required List<TimesheetExternalData> activeTimesheets,
  }) =>
      TaskDetailsState(
        taskWithProjectExternalData: taskWithProjectExternalData,
        timesheets: timesheets,
        activeTimesheets: activeTimesheets,
        isLoading: false,
        isSyncing: false,
        error: null,
      );

  factory TaskDetailsState.error({
    TaskWithProjectExternalData? taskWithProjectExternalData,
    required List<TimesheetExternalData> timesheets,
    required List<TimesheetExternalData> activeTimesheets,
    required Object error,
  }) =>
      TaskDetailsState(
        taskWithProjectExternalData: taskWithProjectExternalData,
        timesheets: timesheets,
        activeTimesheets: activeTimesheets,
        isLoading: false,
        isSyncing: false,
        error: error,
      );
}

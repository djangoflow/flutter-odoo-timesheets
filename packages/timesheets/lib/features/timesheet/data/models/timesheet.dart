// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/timer/timer.dart';

part 'timesheet.freezed.dart';
part 'timesheet.g.dart';

@freezed
class Timesheet with _$Timesheet {
  const factory Timesheet({
    required int id,
    String? description,
    @JsonKey(name: 'project_id') required int projectId,
    @JsonKey(name: 'task_id') required int taskId,
    @JsonKey(name: 'start_time') DateTime? startTime,
    @JsonKey(name: 'end_time') DateTime? endTime,
    @JsonKey(name: 'unit_amount') double? unitAmount,

    /// [FOR LOCALLY USE ONLY] Indicates the current status of the timesheet
    @JsonKey(name: 'timer_state') TimerStatus? timerState,

    /// [FOR LOCALLY USE ONLY] Indicates the last time timer ticked/was running
    /// Needed for total spent time calculation
    @JsonKey(name: 'last_ticked') DateTime? lastTicked,
    @JsonKey(name: 'is_favorite') bool? isFavorite,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Timesheet;

  factory Timesheet.fromJson(Map<String, dynamic> json) =>
      _$TimesheetFromJson(json);
}

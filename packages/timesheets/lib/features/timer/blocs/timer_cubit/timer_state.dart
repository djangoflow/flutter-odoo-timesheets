import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/timesheet/data/database_tables/timesheet.dart';

part 'timer_state.freezed.dart';

// Freezed class for TimerState
@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    required Duration duration,
    required TimesheetStatusEnum status,
  }) = _TimerState;

  factory TimerState.initial() => const TimerState(
        duration: Duration.zero,
        status: TimesheetStatusEnum.initial,
      );

  factory TimerState.running(Duration duration) => TimerState(
        duration: duration,
        status: TimesheetStatusEnum.running,
      );

  factory TimerState.paused(Duration duration) => TimerState(
        duration: duration,
        status: TimesheetStatusEnum.paused,
      );

  factory TimerState.pausedByForce(Duration duration) => TimerState(
        duration: duration,
        status: TimesheetStatusEnum.pausedByForce,
      );

  factory TimerState.stopped(Duration duration) => TimerState(
        duration: duration,
        status: TimesheetStatusEnum.stopped,
      );
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/timer/timer.dart';

part 'timer_state.freezed.dart';

// Freezed class for TimerState
@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    required Duration duration,
    required TimerStatus status,
  }) = _TimerState;

  factory TimerState.initial() => const TimerState(
        duration: Duration.zero,
        status: TimerStatus.initial,
      );

  factory TimerState.running(Duration duration) => TimerState(
        duration: duration,
        status: TimerStatus.running,
      );

  factory TimerState.paused(Duration duration) => TimerState(
        duration: duration,
        status: TimerStatus.paused,
      );

  factory TimerState.pausedByForce(Duration duration) => TimerState(
        duration: duration,
        status: TimerStatus.pausedByForce,
      );

  factory TimerState.stopped(Duration duration) => TimerState(
        duration: duration,
        status: TimerStatus.stopped,
      );
}

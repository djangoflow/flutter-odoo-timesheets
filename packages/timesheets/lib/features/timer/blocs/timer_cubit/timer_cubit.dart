import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

import 'timer_state.dart';

export 'timer_state.dart';

// Timer Cubit
class TimerCubit extends Cubit<TimerState> {
  Timer? _timer;
  Duration? _elapsedTime;
  final Duration tickDuration;

  set elapsedTime(Duration? value) => _elapsedTime = value;

  TimerCubit({
    this.tickDuration = const Duration(seconds: 1),
    required TimerState initialState,
  })  : _elapsedTime = initialState.duration,
        super(initialState);

  void startTimer() {
    emit(TimerState.running(_elapsedTime ?? Duration.zero));
    _timer = Timer.periodic(tickDuration, (_) {
      // should check as sometimes the timer is not cancelled in time
      if (state.status == TimesheetStatusEnum.running) {
        _elapsedTime ??= Duration.zero;
        _elapsedTime = _elapsedTime! + tickDuration;

        emit(TimerState.running(_getDurationOrZero(_elapsedTime)));
      }
    });
  }

  void forcePauseTimer() {
    _maybeCancelTimer();
    emit(TimerState.pausedByForce(_getDurationOrZero(_elapsedTime)));
  }

  void pauseTimer() {
    _maybeCancelTimer();
    emit(TimerState.paused(_getDurationOrZero(_elapsedTime)));
  }

  void stopTimer() {
    _maybeCancelTimer();
    emit(TimerState.stopped(_getDurationOrZero(_elapsedTime)));
  }

  void resetTimer() {
    _maybeCancelTimer();
    _elapsedTime = Duration.zero;
    emit(TimerState.initial());
  }

  void resumeTimer() {
    _maybeCancelTimer();
    startTimer();
  }

  void _maybeCancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  // Method that will take duration and return duration or zero
  Duration _getDurationOrZero(Duration? duration) => duration ?? Duration.zero;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'timer_state.dart';

export 'timer_state.dart';

// Timer Cubit
class TimerCubit extends Cubit<TimerState> {
  late Timer _timer;
  late Duration _elapsedTime;
  final Duration tickDuration;

  TimerCubit({
    this.tickDuration = const Duration(seconds: 1),
    required TimerState initialState,
  })  : _elapsedTime = initialState.duration,
        super(initialState);

  void startTimer() {
    emit(TimerState.running(_elapsedTime));
    _timer = Timer.periodic(tickDuration, (_) {
      _elapsedTime += tickDuration;
      emit(TimerState.running(_elapsedTime));
    });
  }

  void forcePauseTimer() {
    _maybeCancelTimer();
    emit(TimerState.pausedByForce(_elapsedTime));
  }

  void pauseTimer() {
    _maybeCancelTimer();
    emit(TimerState.paused(_elapsedTime));
  }

  void stopTimer() {
    _maybeCancelTimer();
    emit(TimerState.stopped(_elapsedTime));
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
    if (_timer.isActive) _timer.cancel();
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}

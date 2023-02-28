import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/timer/timer.dart';

part 'timer_bloc.freezed.dart';

part 'timer_bloc.g.dart';

class TimerBloc extends HydratedBloc<TimerEvent, TimerState> {
  final TimeSheetTicker _timeSheetTicker;

  /// For listening to the ticker stream
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required TimeSheetTicker timeSheetTicker})
      : _timeSheetTicker = timeSheetTicker,
        super(const TimerState()) {
    // Edge case if somehow the timer is running when the app is closed which was not detected by lifecycle listener
    // if (state.status == TimerStatus.running && _tickerSubscription == null) {
    //   add(const TimerEvent.started());
    // }
    on<TimerEvent>((event, emit) {
      event.when(
        started: () => _onStarted(emit),
        paused: () => _onPaused(state.duration, emit),
        reset: () => _onReset(emit),
        resumed: (int? duration) =>
            _onResumed(duration ?? state.duration, emit),
        ticked: (duration) => _onTicked(duration, emit),
      );
    });

    //Resumes timer when app launched from killed state
    if (state.status == TimerStatus.running && _tickerSubscription == null) {
      resumeTimerOnAppForeground();
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(emit) {
    _subscribeToTicker();
  }

  void _subscribeToTicker({int? duration}) {
    // In case there is an existing subscription, we have to cancel it
    _tickerSubscription?.cancel();

    // makes the subscription listen to TimerTicked state
    _tickerSubscription = _timeSheetTicker
        .tick(duration ?? 0)
        .listen((duration) => add(TimerEvent.ticked(duration: duration)));
  }

  void _onTicked(int duration, Emitter<TimerState> emit) {
    emit(state.copyWith(
      duration: duration,
      status: TimerStatus.running,
      lastTicked: DateTime.now(),
    ));
  }

  void _onPaused(int duration, Emitter<TimerState> emit) {
    // As the timer pause, we should pause the subscription also
    _tickerSubscription?.pause();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void _onResumed(int duration, Emitter<TimerState> emit) {
    //Duration comes from state if normal resume is done
    //Otherwise comes from calculating against last ticked time

    //Used OR logic as [_tickerSubscription] may be null when timer was paused and app was killed
    if (state.status == TimerStatus.running || _tickerSubscription == null) {
      _subscribeToTicker(duration: duration);
    } else {
      // As the timer resume, we must let the subscription resume also
      _tickerSubscription?.resume();
    }
  }

  void resumeTimerOnAppForeground() {
    final lastTicked = state.lastTicked;
    if (lastTicked != null) {
      final now = DateTime.now();
      final elapsedSinceLastTicked = now.difference(lastTicked).inSeconds;
      final timerDuration = elapsedSinceLastTicked + state.duration;
      add(TimerEvent.resumed(duration: timerDuration));
    } else {
      add(const TimerEvent.resumed());
    }
  }

  void _onReset(Emitter<TimerState> emit) {
    // Timer counting finished, so we must cancel the subscription
    _tickerSubscription?.cancel();
    emit(state.copyWith(
      duration: 0,
      status: TimerStatus.initial,
      lastTicked: null,
    ));
  }

  @override
  TimerState? fromJson(Map<String, dynamic> json) => TimerState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(TimerState state) => state.toJson();
}

@freezed
class TimerEvent with _$TimerEvent {
  const factory TimerEvent.started() = _TimerStarted;

  const factory TimerEvent.paused() = _TimerPaused;

  ///[duration] is non null when app resumes from background
  ///or launched from killed state while an activity was active
  const factory TimerEvent.resumed({int? duration}) = _TimerResumed;

  const factory TimerEvent.ticked({required int duration}) = _TimerTicked;

  const factory TimerEvent.reset() = _TimerReset;
}

@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    @Default(0) int duration,
    @Default(TimerStatus.initial) TimerStatus status,
    DateTime? lastTicked,
  }) = _TimerState;

  factory TimerState.fromJson(Map<String, dynamic> json) =>
      _$TimerStateFromJson(json);
}

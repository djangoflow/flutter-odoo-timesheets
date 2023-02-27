import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/timer/timer.dart';

part 'timer_bloc.freezed.dart';

part 'timer_bloc.g.dart';

class TimerBloc extends HydratedBloc<TimerEvent, TimerState> {
  final TimeSheetTicker _ticker;

  /// to listen to the ticker stream
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required TimeSheetTicker ticker})
      : _ticker = ticker,
        super(const TimerState()) {
    // Edge case if somehow the timer is running when the app is closed which was not detected by lifecycle listener
    // if (state.status == TimerStatus.running && _tickerSubscription == null) {
    //   add(const TimerEvent.started());
    // }
    on<TimerEvent>((event, emit) {
      event.when(
        started: () => _onStarted(emit),
        paused: (lastTicked) {
          _onPaused(state.duration, emit, lastTicked);
        },
        reset: () {
          _onReset(state.duration, emit);
        },
        resumed: (int? duration) {
          _onResumed(duration ?? state.duration, emit, state.status);
        },
        ticked: (duration) {
          _onTicked(duration, emit);
        },
      );
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(emit, {int? duration}) {
    /// In case of there is an subscription exists, we have to cancel it
    _tickerSubscription?.cancel();

    /// makes the subscription listen to TimerTicked state
    _tickerSubscription = _ticker
        .tick(duration ?? 0)
        .listen((duration) => add(_TimerTicked(duration: duration)));
  }

  void _onTicked(int duration, Emitter<TimerState> emit) {
    emit(state.copyWith(
      duration: duration,
      status: TimerStatus.running,
      lastTicked: null,
    ));
  }

  void _onPaused(int duration, Emitter<TimerState> emit, DateTime? lastTicked) {
    /// As the timer pause, we should pause the subscription also
    _tickerSubscription?.pause();
    if (lastTicked == null) {
      emit(state.copyWith(status: TimerStatus.paused));
    } else {
      emit(state.copyWith(
        status: TimerStatus.pausedByForce,
        lastTicked: lastTicked,
      ));
    }
  }

  void _onResumed(int duration, Emitter<TimerState> emit, TimerStatus status) {
    ///Timer paused due to app closed/going to background
    if (status == TimerStatus.pausedByForce || _tickerSubscription == null) {
      _onStarted(emit, duration: duration);
    } else {
      /// As the timer resume, we must let the subscription resume also
      _tickerSubscription?.resume();
      emit(state.copyWith(status: TimerStatus.running));
    }
  }

  void _onReset(int duration, Emitter<TimerState> emit) {
    /// Timer counting finished, so we must cancel the subscription
    _tickerSubscription?.cancel();
    emit(state.copyWith(duration: 0, status: TimerStatus.initial));
  }

  @override
  TimerState? fromJson(Map<String, dynamic> json) => TimerState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(TimerState state) => state.toJson();
}

@freezed
class TimerEvent with _$TimerEvent {
  const factory TimerEvent.started() = _TimerStarted;

  const factory TimerEvent.paused({DateTime? lastTicked}) = _TimerPaused;

  ///duration is non null when app resumes from force paused state to make up for uncounted time
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

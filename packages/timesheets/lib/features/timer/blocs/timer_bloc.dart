import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/timer/timer.dart';

part 'timer_bloc.freezed.dart';

part 'timer_bloc.g.dart';

class TimerBloc extends HydratedBloc<TimerEvent, TimerState> {
  final Ticker _ticker;

  /// to listen to the ticker stream
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerState()) {
    on<TimerEvent>((event, emit) {
      event.when(
        started: () => _onStarted(emit),
        paused: () {
          _onPaused(state.duration, emit);
        },
        reset: () {
          _onReset(state.duration, emit);
        },
        resumed: () {
          _onResumed(state.duration, emit);
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
        .listen((duration) => add(_TimerTicked(duration)));
  }

  void _onTicked(int duration, Emitter<TimerState> emit) {
    emit(state.copyWith(duration: duration, status: TimerStatus.running));
  }

  void _onPaused(int duration, Emitter<TimerState> emit) {
    /// As the timer pause, we should pause the subscription also
    _tickerSubscription?.pause();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void _onResumed(int duration, Emitter<TimerState> emit) {
    ///Timer paused due to app close
    if (_tickerSubscription == null) {
      _onStarted(emit, duration: duration);
    }

    /// As the timer resume, we must let the subscription resume also
    _tickerSubscription?.resume();
    emit(state.copyWith(status: TimerStatus.running));
  }

  void _onReset(int duration, Emitter<TimerState> emit) {
    /// Timer counting finished, so we must cancel the subscription
    _tickerSubscription?.cancel();
    emit(state.copyWith(duration: 0, status: TimerStatus.initial));
  }

  @override
  TimerState? fromJson(Map<String, dynamic> json) => TimerState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(TimerState state) {
    ///App closed during running state of timer will pause it
    if (state.status == TimerStatus.running) {
      Map<String, dynamic> json = state.toJson();
      json['status'] = 'paused';
      return json;
    } else {
      return state.toJson();
    }
  }
}

@freezed
class TimerEvent with _$TimerEvent {
  const factory TimerEvent.started() = _TimerStarted;

  const factory TimerEvent.paused() = _TimerPaused;

  const factory TimerEvent.resumed() = _TimerResumed;

  const factory TimerEvent.ticked(int duration) = _TimerTicked;

  const factory TimerEvent.reset() = _TimerReset;
}

@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    @Default(0) int duration,
    @Default(TimerStatus.initial) TimerStatus status,
  }) = _TimerState;

  factory TimerState.fromJson(Map<String, dynamic> json) =>
      _$TimerStateFromJson(json);
}

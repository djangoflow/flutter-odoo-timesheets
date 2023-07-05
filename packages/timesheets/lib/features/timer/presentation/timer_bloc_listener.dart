import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/timer/timer.dart';

class TimerBlocListener extends BlocListener<TimerCubit, TimerState> {
  TimerBlocListener({
    super.key,
    required super.listener,
    required super.child,

    /// listenWhen is used to determine whether or not to call listener,
    /// by default will check TimerStatus changes.
    bool Function(TimerState, TimerState)? listenWhen,
  }) : super(
          listenWhen: listenWhen ??
              (previous, current) => previous.status != current.status,
        );
}

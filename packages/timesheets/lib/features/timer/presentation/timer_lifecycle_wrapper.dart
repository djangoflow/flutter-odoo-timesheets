import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/presentation/listeners/app_lifecycle_listener.dart';
import 'package:timesheets/features/timer/timer.dart';

class TimerLifecycleWrapper extends StatelessWidget {
  const TimerLifecycleWrapper({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final timerBloc = context.read<TimerBloc>();

    return AppLifeCycleListener(
      onLifeCycleStateChanged: (AppLifecycleState? state) {
        if (timerBloc.state.status == TimerStatus.running &&
            state == AppLifecycleState.paused) {
          timerBloc.add(
            const TimerEvent.paused(
              status: TimerStatus.pausedUntilAppResumed,
            ),
          );
        }
        if (state == AppLifecycleState.resumed &&
            timerBloc.state.status == TimerStatus.pausedUntilAppResumed) {
          timerBloc.resumeTimerOnAppForeground();
        }
      },
      child: child,
    );
  }
}

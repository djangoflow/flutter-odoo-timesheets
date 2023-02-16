import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/blocs/activity_cubit.dart';
import 'package:timesheets/features/timer/data/timer_status.dart';
import 'package:timesheets/features/timer/timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  final double iconSize = 40;

  @override
  Widget build(BuildContext context) {
    final timerBloc = context.read<TimerBloc>();
    final activityCubit = context.read<ActivityCubit>();

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) => getTimerDisplay(
          state.duration, state.status, timerBloc, activityCubit),
    );
  }

  Widget getTimerDisplay(
    int durationInSeconds,
    TimerStatus status,
    TimerBloc timerBloc,
    ActivityCubit activityCubit,
  ) {
    Duration duration = Duration(seconds: durationInSeconds);

    return Padding(
      padding: const EdgeInsets.all(kPadding * 3),
      child: Column(
        children: [
          Text(
            format(duration),
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(
            height: kPadding * 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (status != TimerStatus.running)
                IconButton(
                  onPressed: () {
                    if (status == TimerStatus.paused) {
                      timerBloc.add(const TimerEvent.resumed());
                    } else {
                      timerBloc.add(const TimerEvent.started());
                    }
                  },
                  icon: Icon(
                    Icons.play_arrow_rounded,
                    size: iconSize,
                  ),
                ),
              if (status == TimerStatus.running)
                IconButton(
                  onPressed: () {
                    timerBloc.add(const TimerEvent.paused());
                  },
                  icon: Icon(
                    Icons.pause_circle,
                    size: iconSize,
                  ),
                ),
              if (status != TimerStatus.initial)
                IconButton(
                  onPressed: () {
                    timerBloc.add(const TimerEvent.reset());

                    //Todo change to sync work
                    activityCubit.resetActivity();
                    // activityCubit.syncWork();
                  },
                  icon: Icon(
                    Icons.square_rounded,
                    size: iconSize,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, '0');
}

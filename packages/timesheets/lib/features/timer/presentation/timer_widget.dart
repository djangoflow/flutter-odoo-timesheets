import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/authentication/authentication.dart';
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
    final user = context.watch<AuthCubit>().state.user;

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) => getTimerDisplay(
        state.duration,
        state.status,
        timerBloc,
        activityCubit,
        user,
      ),
    );
  }

  Widget getTimerDisplay(
    int durationInSeconds,
    TimerStatus status,
    TimerBloc timerBloc,
    ActivityCubit activityCubit,
    User? user,
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
                    DateTime startTime = activityCubit.state.startTime!;
                    DateTime endTime = startTime.add(duration);

                    final DateFormat formatter =
                        DateFormat('yyyy-MM-dd HH:mm:ss');

                    Activity activity = Activity(
                      name: activityCubit.state.description!,
                      projectId: activityCubit.state.project!.id,
                      taskId: activityCubit.state.task!.id,
                      startTime: formatter.format(startTime),
                      endTime: formatter.format(endTime),
                    );
                    activityCubit.syncActivity(
                      activity: activity,
                      id: user!.id,
                      password: user.pass,
                    );
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

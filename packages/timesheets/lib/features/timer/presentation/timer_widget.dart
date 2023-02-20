import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/app/app.dart';
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
  void initState() {
    final timerBloc = context.read<TimerBloc>();

    ///Checking for active timer when app opened from killed state
    if (timerBloc.state.status == TimerStatus.pausedByForce) {
      _resumeTimerOnAppForeground(timerBloc);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final timerBloc = context.read<TimerBloc>();
    final activityCubit = context.read<ActivityCubit>();
    final user = context.watch<AuthCubit>().state.user;

    return AppLifeCycleListener(
      onLifeCycleStateChanged: (AppLifecycleState? state) {
        if (timerBloc.state.status == TimerStatus.pausedByForce) {
          ///Checking for active timer when app opened from background state
          _resumeTimerOnAppForeground(timerBloc);
        } else if (timerBloc.state.status == TimerStatus.running) {
          if (state == AppLifecycleState.paused ||
              state == AppLifecycleState.detached) {
            timerBloc.add(TimerEvent.paused(lastTicked: DateTime.now()));
          }
        }
      },
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          Duration duration = Duration(seconds: state.duration);
          TimerStatus status = state.status;
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
                          } else if (status == TimerStatus.initial) {
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
        },
      ),
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, '0');

  _resumeTimerOnAppForeground(TimerBloc timerBloc) {
    DateTime? lastTicked = timerBloc.state.lastTicked;
    if (lastTicked != null) {
      DateTime now = DateTime.now();
      int elapsedSinceLastTicked = now.difference(lastTicked).inSeconds;
      int timerDuration = elapsedSinceLastTicked + timerBloc.state.duration;
      timerBloc.add(TimerEvent.resumed(duration: timerDuration));
    } else {
      timerBloc.add(const TimerEvent.resumed());
    }
  }
}

import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/timer/presentation/timer_lifecycle_wrapper.dart';
import 'package:timesheets/features/timer/timer.dart';

class LargeTimerWidget extends StatelessWidget {
  const LargeTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final activityCubit = context.read<ActivityCubit>();

    return TimerLifecycleWrapper(
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final timerBloc = context.read<TimerBloc>();
          Duration duration = Duration(seconds: state.duration);
          TimerStatus status = state.status;
          return Padding(
            padding: const EdgeInsets.all(kPadding * 3),
            child: Column(
              children: [
                Text(
                  _format(duration: duration),
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
                          if (status == TimerStatus.paused ||
                              status == TimerStatus.pausedUntilAppResumed) {
                            timerBloc.add(const TimerEvent.resumed());
                          } else if (status == TimerStatus.initial) {
                            timerBloc.add(const TimerEvent.started());
                          }
                        },
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          size: iconSizeBig,
                        ),
                      )
                    else
                      IconButton(
                        onPressed: () {
                          timerBloc.add(const TimerEvent.paused());
                        },
                        icon: const Icon(
                          Icons.pause_circle,
                          size: iconSizeBig,
                        ),
                      ),
                    if (status != TimerStatus.initial)
                      IconButton(
                        onPressed: () async {
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
                          await activityCubit.syncActivity(
                            activity: activity,
                          );

                          DjangoflowAppSnackbar.showInfo('Activity Synced!');
                        },
                        icon: const Icon(
                          Icons.square_rounded,
                          size: iconSizeBig,
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

  _format({required Duration duration}) =>
      duration.toString().split('.').first.padLeft(8, '0');
}

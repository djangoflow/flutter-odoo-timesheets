import 'package:drift/drift.dart' hide Column;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage()
class TaskDetailsPage extends StatelessWidget with AutoRouteWrapper {
  const TaskDetailsPage({super.key, @pathParam required this.taskId});
  final int taskId;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDataCubit, TasksDataState>(
        builder: (context, state) {
          final task = state.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(task != null ? 'Task ${task.name}' : 'Task details'),
              actions: [
                if (task != null)
                  IconButton(
                    onPressed: () {
                      context.router.push(
                        TaskEditRoute(task: task),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  )
              ],
            ),
            body: state.map(
              (value) => value.data == null
                  ? const Center(
                      child: Text(
                        'No data!',
                      ),
                    )
                  : _TaskDetails(
                      task: value.data!,
                    ),
              loading: (value) => const Center(
                child: CircularProgressIndicator(),
              ),
              empty: (value) => const Center(
                child: Text(
                  'No data!',
                ),
              ),
              error: (value) => const Center(
                child: Text(
                  'Something went wrong!',
                ),
              ),
            ),
          );
        },
      );

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (context) => TaskDataCubit(context.read<TasksRepository>())
          ..load(
            TaskRetrieveFilter(taskId: taskId),
          ),
        child: this,
      );
}

class _TaskDetails extends StatelessWidget {
  const _TaskDetails({super.key, required this.task});
  final Task task;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final elapsedTime = task.elapsedTime;

    return ListView(
      children: [
        if (task.description != null)
          _TaskDescription(
            description: task.description!,
          ),
        Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: kPadding.h * 2,
              ),
              child: TaskTimer.large(
                key: ValueKey(task.status),
                disabled: false,
                elapsedTime: task.duration,
                initialTimerStatus: TimerStatus.values[task.status],
                onTimerResume: (context) {
                  context.read<TimerCubit>().elapsedTime = Duration(
                    seconds: elapsedTime,
                  );
                },
                onTimerStateChange: (timerState, tickDurationInSeconds) async {
                  final taskDataCubit = context.read<TaskDataCubit>();

                  final isRunning = timerState.status == TimerStatus.running;
                  final updatableSeconds =
                      (isRunning ? tickDurationInSeconds : 0);
                  final lastTickedValue =
                      isRunning ? DateTime.now() : task.lastTicked;

                  if (isRunning && task.firstTicked == null) {
                    task.copyWith(
                      firstTicked: Value(DateTime.now()),
                    );
                  }

                  await taskDataCubit.updateTask(
                    task.copyWith(
                      duration: elapsedTime + updatableSeconds,
                      status: timerState.status.index,
                      lastTicked: Value(lastTickedValue),
                    ),
                  );

                  if (timerState.status == TimerStatus.stopped) {
                    if (context.mounted) {
                      final result = await _showActionSheet(context);
                      if (result == null || result == _TaskStopAction.cancel) {
                        await taskDataCubit.updateTask(
                          task.copyWith(
                            status: TimerStatus.paused.index,
                          ),
                        );
                      } else if (result == _TaskStopAction.saveLocally) {
                        print('Saving locally');
                      }
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<_TaskStopAction?> _showActionSheet(BuildContext context) =>
      showCupertinoModalPopup<_TaskStopAction?>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          message: const Text('Timesheet is not synchronized'),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              context.router.pop(_TaskStopAction.cancel);
            },
            child: const Text('Cancel'),
          ),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                context.router.pop(_TaskStopAction.syncOdoo);
              },
              child: const Text('Connect wih Odoo account'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                context.router.pop(_TaskStopAction.saveLocally);
              },
              child: const Text('Save locally'),
            ),
          ],
        ),
      );
}

class _TaskDescription extends StatelessWidget {
  const _TaskDescription({super.key, required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.all(kPadding.h * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Description',
            style: textTheme.titleMedium,
          ),
          SizedBox(height: kPadding.h),
          Text(
            description,
          ),
        ],
      ),
    );
  }
}

enum _TaskStopAction { syncOdoo, cancel, saveLocally }

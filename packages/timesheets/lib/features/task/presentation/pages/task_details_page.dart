import 'package:drift/drift.dart' hide Column;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage()
class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDataCubit, TasksDataState>(
        builder: (context, state) {
          final taskWithProject = state.data;
          final task = taskWithProject?.task;
          final timesheets = context.select(
            (TimesheetListCubit cubit) => cubit.state.data,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(task != null ? 'Task ${task.name}' : 'Task details'),
              leading: const AutoLeadingButton(),
              actions: [
                if (taskWithProject != null)
                  IconButton(
                    onPressed: () {
                      context.router.push(
                        TaskEditRoute(taskWithProject: taskWithProject),
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
                  : ListView(
                      children: [
                        _TaskDetails(
                          task: value.data!.task,
                        ),
                        SizedBox(
                          height: kPadding.h,
                        ),
                        _TimesheetListView(
                          timesheets: timesheets ?? [],
                        ),
                      ],
                    ),
              loading: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
              empty: (_) => const Center(
                child: Text(
                  'No data!',
                ),
              ),
              error: (_) => const Center(
                child: Text(
                  'Something went wrong!',
                ),
              ),
            ),
          );
        },
      );
}

class _TaskDetails extends StatelessWidget {
  const _TaskDetails({required this.task});
  final Task task;
  @override
  Widget build(BuildContext context) {
    final elapsedTime = task.elapsedTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (task.description != null)
          _TaskDescription(
            description: task.description!,
          ),
        Card(
          margin: EdgeInsets.zero,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: kPadding.h * 2,
              ),
              child: TaskTimer.large(
                key: ValueKey(task.status == TimerStatus.initial.index),
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
                  final timesheetListCubit = context.read<TimesheetListCubit>();

                  final isRunning = timerState.status == TimerStatus.running;
                  final updatableSeconds =
                      (isRunning ? tickDurationInSeconds : 0);
                  final firstTickedValue =
                      (isRunning && task.firstTicked == null)
                          ? DateTime.now()
                          : task.firstTicked;
                  final lastTickedValue =
                      isRunning ? DateTime.now() : task.lastTicked;
                  final updatableTask = task.copyWith(
                    duration: elapsedTime + updatableSeconds,
                    status: timerState.status.index,
                    firstTicked: Value(firstTickedValue),
                    lastTicked: Value(lastTickedValue),
                  );
                  await taskDataCubit.updateTask(updatableTask);

                  // update task locally in task list cubit

                  if (timerState.status == TimerStatus.stopped) {
                    if (context.mounted) {
                      final result = await _showActionSheet(context);
                      if (result == null || result == _TaskStopAction.cancel) {
                        await taskDataCubit.updateTask(
                          updatableTask.copyWith(
                            status: TimerStatus.paused.index,
                          ),
                        );
                      } else if (result == _TaskStopAction.saveLocally) {
                        if (task.firstTicked == null ||
                            task.lastTicked == null) {
                          throw Exception('Timer was not started');
                        }
                        await timesheetListCubit.createTimesheet(
                          TimesheetsCompanion(
                            taskId: Value(task.id),
                            totalSpentSeconds: Value(task.duration),
                            startTime: Value(task.firstTicked!),
                            finishTime: Value(task.lastTicked!),
                          ),
                        );

                        await taskDataCubit.resetTask(task);
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
  const _TaskDescription({required this.description});
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

class _TimesheetListView extends StatelessWidget {
  const _TimesheetListView({required this.timesheets});
  final List<Timesheet> timesheets;

  @override
  Widget build(BuildContext context) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: timesheets.length,
        separatorBuilder: (context, index) => SizedBox(
          height: kPadding.h,
        ),
        itemBuilder: (context, index) {
          final timesheet = timesheets[index];

          return ListTile(
            key: ValueKey(timesheet.id),
            onTap: () => context.router.push(
              TimesheetsRouter(
                timesheetId: timesheet.id,
                children: const [
                  TimesheetDetailsRoute(),
                ],
              ),
            ),
            title: Text(
              DateFormat.yMd().format(timesheet.startTime),
            ),
            subtitle: Text(
              DateFormat.jms().format(timesheet.startTime),
            ),
            trailing: Text(
              Duration(
                seconds: timesheet.totalSpentSeconds,
              ).timerString(
                DurationFormat.hoursMinutesSeconds,
              ),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          );
        },
      );
}

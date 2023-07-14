import 'package:drift/drift.dart' hide Column;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage()
class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          final taskWithProject = state.taskWithProject;
          final task = taskWithProject?.task;

          final timesheets = state.timesheets;
          Widget body;

          if (state.isLoading) {
            body = const Center(
              child: CircularProgressIndicator(),
            );
          }

          body = ListView(
            children: [
              if (taskWithProject != null)
                _TaskDetails(
                  key: ValueKey(taskWithProject.task.onlineId),
                  taskWithProject: taskWithProject,
                  isSyncing: state.isSyncing,
                ),
              SizedBox(
                height: kPadding.h,
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  final user = authState.odooUser;
                  if (user != null && timesheets.isNotEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: kPadding.h * 2,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: kPadding.h * 2,
                            ),
                            child: LinearProgressBuilder(
                              action: (_) async {
                                final taskDetailsCubit =
                                    context.read<TaskDetailsCubit>();

                                await taskDetailsCubit
                                    .syncAllTimesheets(hardcodedBackendId);
                              },
                              onSuccess: () => AppDialog.showSuccessDialog(
                                context: context,
                                title: 'Success',
                                content:
                                    'Timesheets synced successfully, cheers!',
                              ),
                              builder: (context, action, error) =>
                                  ElevatedButton.icon(
                                icon: const Icon(
                                    CupertinoIcons.arrow_2_circlepath),
                                onPressed: action,
                                label: const Text('Sync timesheets with Odoo'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: kPadding.h * 3,
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
              _TimesheetListView(
                key: ValueKey(timesheets),
                timesheets: timesheets,
              ),
            ],
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(task != null ? 'Task ${task.name}' : 'Task details'),
              leading: const AutoLeadingButton(),
              actions: [
                if (taskWithProject != null &&
                    taskWithProject.task.onlineId == null)
                  IconButton(
                    onPressed: () {
                      context.router
                          .push(
                        TaskEditRoute(taskWithProject: taskWithProject),
                      )
                          .then((value) {
                        if (value != null && value == true) {
                          context.router.pop(true);
                        }
                      });
                    },
                    icon: const Icon(Icons.edit),
                  )
              ],
            ),
            body: body,
          );
        },
      );
}

class _TaskDetails extends StatelessWidget {
  const _TaskDetails(
      {super.key, required this.taskWithProject, required this.isSyncing});
  final TaskWithProject taskWithProject;
  final bool isSyncing;
  @override
  Widget build(BuildContext context) {
    final task = taskWithProject.task;
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
              child: Column(
                children: [
                  _TaskStartedDetails(
                    firstTicked: task.firstTicked,
                  ),
                  SizedBox(
                    height: kPadding.h,
                  ),
                  TaskTimer.large(
                    key: ValueKey(task.status == TimerStatus.initial.index),
                    disabled: isSyncing,
                    elapsedTime: task.duration,
                    initialTimerStatus: TimerStatus.values[task.status],
                    onTimerResume: (context) {
                      context.read<TimerCubit>().elapsedTime = Duration(
                        seconds: elapsedTime,
                      );
                    },
                    onTimerStateChange:
                        (timerState, tickDurationInSeconds) async {
                      final router = context.router;
                      final taskDetailsCubit = context.read<TaskDetailsCubit>();

                      final isRunning =
                          timerState.status == TimerStatus.running;
                      final updatableSeconds =
                          (isRunning ? tickDurationInSeconds : 0);
                      final firstTickedValue =
                          (isRunning && task.firstTicked == null)
                              ? DateTime.now()
                              : task.firstTicked;
                      final lastTickedValue =
                          isRunning ? DateTime.now() : task.lastTicked;
                      Task updatableTask = task.copyWith(
                        duration: elapsedTime + updatableSeconds,
                        status: timerState.status.index,
                        firstTicked: Value(firstTickedValue),
                        lastTicked: Value(lastTickedValue),
                      );
                      await taskDetailsCubit.updateTask(updatableTask);

                      // update task locally in task list cubit

                      if (timerState.status == TimerStatus.stopped) {
                        if (context.mounted) {
                          if (context.read<AuthCubit>().isAuthenticated &&
                              task.onlineId != null) {
                            _syncTask(
                              context: context,
                              task: task,
                              backendId: hardcodedBackendId,
                            );
                          } else {
                            final result = await _showActionSheet(context);
                            if (result == null ||
                                result == _TaskStopAction.cancel) {
                              await taskDetailsCubit.updateTask(
                                updatableTask.copyWith(
                                  status: TimerStatus.paused.index,
                                ),
                              );
                            } else if (result == _TaskStopAction.saveLocally) {
                              if (context.mounted) {
                                await _syncTask(context: context, task: task);
                              }
                            } else if (result == _TaskStopAction.syncOdoo) {
                              updatableTask = updatableTask.copyWith(
                                status: TimerStatus.paused.index,
                              );
                              await taskDetailsCubit.updateTask(updatableTask);
                              final didUpdateTask = await router.push(
                                OdooTaskAddRoute(
                                  taskWithProject: taskWithProject.copyWith(
                                    task: updatableTask,
                                  ),
                                ),
                              );
                              if (context.mounted) {
                                final latestTask = await taskDetailsCubit
                                    .tasksRepository
                                    .getTaskById(task.id);
                                if (latestTask != null && context.mounted) {
                                  await _syncTask(
                                    context: context,
                                    task: latestTask,
                                    backendId: hardcodedBackendId,
                                  );
                                  debugPrint(
                                      'updated task $didUpdateTask ${task.id}');
                                  if (didUpdateTask != null) {
                                    taskDetailsCubit.loadTaskDetails(task.id);
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Sync task with Odoo or locally, depending on `backendId` value
  Future<void> _syncTask(
      {required BuildContext context,
      required Task task,
      int? backendId}) async {
    final taskDetailsCubit = context.read<TaskDetailsCubit>();
    if (task.firstTicked == null || task.lastTicked == null) {
      throw Exception('Timer was not started');
    }
    try {
      await taskDetailsCubit.createTimesheet(
        timesheetsCompanion: TimesheetsCompanion(
          taskId: Value(task.id),
          totalSpentSeconds: Value(task.duration),
          startTime: Value(task.firstTicked!),
          endTime: Value(task.lastTicked!),
        ),
        backendId: backendId,
      );
      await taskDetailsCubit.resetTask(task);
      if (context.mounted) {
        AppDialog.showSuccessDialog(
          context: context,
          title: 'Timesheet submitted',
          content:
              'Your timesheet has been successfully ${backendId == null ? 'saved locally' : 'sent to your Odoo account'}.',
        );
      }
    } catch (e) {
      if (e is OdooRepositoryException) {
        await taskDetailsCubit.resetTask(task);
        if (context.mounted) {
          AppDialog.showSuccessDialog(
            context: context,
            title: 'Timesheet submitted',
            content: 'Your timesheet has been successfully saved locally.',
          );
        }
      }
      throw Exception(
          'Seems like you are offline. But changes were saved locally.');
    }
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

class _TaskStartedDetails extends StatelessWidget {
  const _TaskStartedDetails({super.key, this.firstTicked});
  final DateTime? firstTicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          firstTicked != null
              ? DateFormat('dd/MM/yyyy').format(firstTicked!)
              : 'Timer not started',
          style: textTheme.titleMedium,
        ),
        Text(
          firstTicked != null
              ? 'Time Started ${DateFormat('HH:mm:ss').format(firstTicked!)}'
              : 'Please start the timer to track time',
          style: textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

enum _TaskStopAction { syncOdoo, cancel, saveLocally }

class _TimesheetListView extends StatelessWidget {
  const _TimesheetListView({super.key, required this.timesheets});
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
            leading: Icon(
              timesheet.onlineId == null
                  ? CupertinoIcons.cloud_upload_fill
                  : CupertinoIcons.check_mark_circled_solid,
              size: 32,
            ),
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

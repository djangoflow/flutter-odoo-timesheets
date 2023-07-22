import 'package:drift/drift.dart' hide Column;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/assets.gen.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage()
class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          final taskWithProjectExternalData = state.taskWithProjectExternalData;
          final task = taskWithProjectExternalData?.taskWithExternalData.task;
          final project =
              taskWithProjectExternalData?.projectWithExternalData.project;
          final externalProject = taskWithProjectExternalData
              ?.projectWithExternalData.externalProject;

          final timesheets = state.timesheets;
          final activeTimesheets = state.activeTimesheets;

          Widget body;

          if (state.isLoading) {
            body = const Center(
              child: CircularProgressIndicator(),
            );
          }

          body = ListView(
            children: [
              if (project?.name != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kPadding.w * 2,
                    vertical: kPadding.h,
                  ),
                  child: _ProjectLabel(title: project!.name!),
                ),
              if (task?.name != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kPadding.w * 2,
                    vertical: kPadding.h,
                  ),
                  child: _TaskLabel(title: task!.name!),
                ),
              Column(
                children: activeTimesheets
                    .map(
                      (e) => _ActiveTimesheetDetails(
                        key: ValueKey(e.timesheet.id),
                        activeTimesheetExternalData: e,
                        isSyncing: state.isSyncing,
                        backendId: externalProject?.backendId,
                      ),
                    )
                    .toList(),
              ),
              SizedBox(
                height: kPadding.h,
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  // final user = authState.odooUser;
                  if (timesheets.isNotEmpty) {
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
                            child: Stack(
                              children: [
                                if (!state.isSyncing)
                                  LinearProgressBuilder(
                                    action: (_) async {
                                      final taskDetailsCubit =
                                          context.read<TaskDetailsCubit>();

                                      await taskDetailsCubit.syncAllTimesheets(
                                          hardcodedBackendId);
                                    },
                                    onSuccess: () =>
                                        AppDialog.showSuccessDialog(
                                      context: context,
                                      title: 'Success',
                                      content:
                                          'Timesheets synced successfully, cheers!',
                                    ),
                                    builder: (context, action, error) =>
                                        SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(
                                            CupertinoIcons.arrow_2_circlepath),
                                        onPressed: action,
                                        label: const Text(
                                            'Sync timesheets with Odoo'),
                                      ),
                                    ),
                                  ),
                                if (state.isSyncing)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Skeletonizer(
                                      enabled: true,
                                      child: ElevatedButton.icon(
                                        onPressed: null,
                                        label: const Skeleton.keep(
                                          child: Text(
                                            'Syncing',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(
                                          CupertinoIcons.arrow_2_circlepath,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (state.isSyncing)
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Lottie.asset(
                                            Assets.animationSyncing,
                                            height: kPadding * 3,
                                            width: kPadding * 3,
                                            repeat: true,
                                          ),
                                          SizedBox(
                                            width: kPadding.w,
                                          ),
                                          Text(
                                            'Syncing...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ],
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
                if (taskWithProjectExternalData != null &&
                    taskWithProjectExternalData
                            .taskWithExternalData.externalTask ==
                        null)
                  IconButton(
                    onPressed: () {
                      // context.router
                      //     .push(
                      //   TaskEditRoute(
                      //       taskWithProjectExternalData:
                      //           taskWithProjectExternalData),
                      // )
                      //     .then((value) {
                      //   if (value != null && value == true) {
                      //     context.router.pop(true);
                      //   }
                      // });
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

class _ActiveTimesheetDetails extends StatelessWidget {
  const _ActiveTimesheetDetails({
    super.key,
    required this.isSyncing,
    required this.activeTimesheetExternalData,
    this.backendId,
  });

  final TimesheetExternalData activeTimesheetExternalData;
  final bool isSyncing;
  final int? backendId;
  @override
  Widget build(BuildContext context) {
    // TODO should be related to timesheet duration
    final timesheet = activeTimesheetExternalData.timesheet;
    final externalTimesheet = activeTimesheetExternalData.externalTimesheet;
    final elapsedTime = timesheet.elapsedTime;

    return Card(
      margin: EdgeInsets.zero,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: kPadding.h * 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (timesheet.name != null)
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: 'Description: ',
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: timesheet.name!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              _TimesheetDateDetails(
                startTime: timesheet.startTime,
              ),
              SizedBox(
                height: kPadding.h,
              ),
              TaskTimer.large(
                key: ValueKey(
                    timesheet.currentStatus == TimesheetStatusEnum.initial),
                disabled: isSyncing,
                elapsedTime: elapsedTime,
                initialTimerStatus: timesheet.currentStatus,
                onTimerResume: (context) {
                  final currentlyElapsedTime = timesheet.elapsedTime;
                  context.read<TimerCubit>().elapsedTime = Duration(
                    seconds: currentlyElapsedTime,
                  );
                },
                onTimerStateChange:
                    (context, timerState, tickDurationInSeconds) async {
                  final router = context.router;
                  final taskDetailsCubit = context.read<TaskDetailsCubit>();

                  final isRunning =
                      timerState.status == TimesheetStatusEnum.running;
                  final updatableSeconds =
                      (isRunning ? tickDurationInSeconds : 0);
                  final startTimeValue =
                      (isRunning && timesheet.startTime == null)
                          ? DateTime.now()
                          : timesheet.startTime;
                  final lastTickedValue =
                      isRunning ? DateTime.now() : timesheet.lastTicked;
                  Timesheet updatableTimesheet = timesheet.copyWith(
                    unitAmount:
                        Value((elapsedTime + updatableSeconds).toUnitAmount()),
                    currentStatus: timerState.status,
                    startTime: Value(startTimeValue),
                    lastTicked: Value(lastTickedValue),
                  );
                  await taskDetailsCubit.updateTimesheet(updatableTimesheet);

                  // update task locally in task list cubit

                  if (timerState.status == TimesheetStatusEnum.stopped) {
                    if (context.mounted) {
                      if (context
                              .read<AuthCubit>()
                              .state
                              .connectedBackends
                              .getBackendsFilteredByType(BackendTypeEnum.odoo)
                              .isNotEmpty &&
                          externalTimesheet != null &&
                          externalTimesheet.externalId != null) {
                        _syncTimesheet(
                          context: context,
                          timesheet: updatableTimesheet,
                          backendId: backendId,
                        );
                      } else {
                        final result = await _showActionSheet(context);
                        if (result == null ||
                            result == _TaskStopAction.cancel) {
                          await taskDetailsCubit.updateTimesheet(
                            updatableTimesheet.copyWith(
                              currentStatus: TimesheetStatusEnum.paused,
                            ),
                          );
                        } else if (result == _TaskStopAction.saveLocally) {
                          if (context.mounted) {
                            await _syncTimesheet(
                              context: context,
                              timesheet: updatableTimesheet,
                            );
                          }
                        } else if (result == _TaskStopAction.syncOdoo) {
                          updatableTimesheet = updatableTimesheet.copyWith(
                            currentStatus: TimesheetStatusEnum.paused,
                          );
                          await taskDetailsCubit
                              .updateTimesheet(updatableTimesheet);
                          // Need to write logic for merging task to odoo
                          // final didUpdateTask = await router.push(
                          //   OdooTaskAddRoute(
                          //     taskWithProjectExternalData:
                          //         taskWithProjectExternalData.copyWith(
                          //       task: updatableTask,
                          //     ),
                          //   ),
                          // );
                          // if (context.mounted) {
                          //   final latestTask = await taskDetailsCubit
                          //       .taskRepository
                          //       .getTaskById(task.id);
                          //   if (latestTask != null && context.mounted) {
                          //     await _syncTimesheet(
                          //       context: context,
                          //       task: latestTask,
                          //       backendId: hardcodedBackendId,
                          //     );
                          //     debugPrint(
                          //         'updated task $didUpdateTask ${task.id}');
                          //     if (didUpdateTask != null) {
                          //       taskDetailsCubit.loadTaskDetails(task.id);
                          //     }
                          //   }
                          // }
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
    );
  }

  /// Sync task with Odoo or locally, depending on `backendId` value
  Future<void> _syncTimesheet(
      {required BuildContext context,
      required Timesheet timesheet,
      int? backendId}) async {
    final taskDetailsCubit = context.read<TaskDetailsCubit>();
    if (timesheet.startTime == null || timesheet.lastTicked == null) {
      throw Exception('Timer was not started');
    }
    try {
      await taskDetailsCubit.stopWorkingOnTimesheet(timesheet.id);
      if (backendId != null) {
        await taskDetailsCubit.syncTimesheet(timesheet.id, backendId);
      }

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
        await taskDetailsCubit.loadTaskDetails(showLoading: false);
        if (context.mounted) {
          AppDialog.showSuccessDialog(
            context: context,
            title: 'Timesheet submitted',
            content: 'Your timesheet has been successfully saved locally.',
          );
        }
        print(e.message);
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

class _LabeledTitle extends StatelessWidget {
  const _LabeledTitle({
    required this.title,
    required this.label,
  });
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: textTheme.titleSmall,
        ),
        SizedBox(height: kPadding.h / 2),
        Text(
          title,
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ProjectLabel extends _LabeledTitle {
  const _ProjectLabel({required super.title}) : super(label: 'Project');
}

class _TaskLabel extends _LabeledTitle {
  const _TaskLabel({required super.title}) : super(label: 'Task');
}

class _TimesheetDateDetails extends StatelessWidget {
  const _TimesheetDateDetails({super.key, this.startTime});
  final DateTime? startTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          startTime != null
              ? DateFormat('dd/MM/yyyy').format(startTime!)
              : 'Timer not started',
          style: textTheme.titleMedium,
        ),
        Text(
          startTime != null
              ? 'Time Started ${DateFormat('HH:mm:ss').format(startTime!)}'
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
  final List<TimesheetExternalData> timesheets;

  @override
  Widget build(BuildContext context) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: timesheets.length,
        separatorBuilder: (context, index) => SizedBox(
          height: kPadding.h,
        ),
        itemBuilder: (context, index) {
          final timesheet = timesheets[index].timesheet;
          final externalTimesheet = timesheets[index].externalTimesheet;

          return ListTile(
            key: ValueKey(timesheet.id),
            leading: Icon(
              externalTimesheet == null || externalTimesheet.externalId == null
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
              timesheet.startTime != null
                  ? DateFormat.yMd().format(timesheet.startTime!)
                  : 'No starting date',
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timesheet.startTime != null
                      ? DateFormat.jms().format(timesheet.startTime!)
                      : 'No starting time',
                ),
                Text(timesheet.name ?? '/'),
              ],
            ),
            trailing: Text(
              Duration(
                seconds: ((timesheet.unitAmount ?? 0.0) * 3600).toInt(),
              ).timerString(
                DurationFormat.hoursMinutesSeconds,
              ),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          );
        },
      );
}

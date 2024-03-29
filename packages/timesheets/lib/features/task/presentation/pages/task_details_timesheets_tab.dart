import 'dart:ui';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/features/timesheet/presentation/timesheet_expansion_panel.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/assets.gen.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage(
  name: 'TaskDetailsTimesheetsTab',
)
class TaskDetailsTimesheetsTabPage extends StatelessWidget {
  const TaskDetailsTimesheetsTabPage({super.key});

  @override
  Widget build(BuildContext context) => SyncCubitProvider(
        child: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
          builder: (context, state) {
            final taskWithProjectExternalData =
                state.taskWithProjectExternalData;
            final externalProject = taskWithProjectExternalData
                ?.projectWithExternalData.externalProject;

            final timesheets = state.timesheets;
            final activeTimesheets = state.activeTimesheets;
            final externalTask =
                taskWithProjectExternalData?.taskWithExternalData.externalTask;

            Widget body;

            if (state.isLoading) {
              body = const Center(
                child: CircularProgressIndicator(),
              );
            } else if (taskWithProjectExternalData == null) {
              body = const Center(
                child: Text('Task not found'),
              );
            }

            body = BlocListener<SyncCubit, SyncState>(
              listener: (context, syncState) {
                if (syncState.isSuccess) {
                  context
                      .read<TaskDetailsCubit>()
                      .loadTaskDetails(showLoading: false);
                }
              },
              listenWhen: (previous, current) => current.isSuccess,
              child: BlocBuilder<SyncCubit, SyncState>(
                builder: (context, syncState) => RefreshIndicator(
                  onRefresh: () async {
                    await context.read<TaskDetailsCubit>().loadTaskDetails();
                  },
                  child: Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: kPadding.h * 2,
                          vertical: kPadding.h * 3,
                        ),
                        children: [
                          if (activeTimesheets.isEmpty)
                            Column(
                              children: [
                                Text(
                                  'No active timesheets, create a timer to begin!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                SizedBox(
                                  height: kPadding.h * 2,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      final taskDetailsCubit =
                                          context.read<TaskDetailsCubit>();
                                      final result = await context.router.push(
                                        TimesheetRouter(children: [
                                          TimesheetAddRoute(
                                            disableProjectTaskSelection: false,
                                            taskWithProjectExternalData:
                                                taskWithProjectExternalData,
                                          ),
                                        ]),
                                      );
                                      if (result != null &&
                                          result is bool &&
                                          result) {
                                        await taskDetailsCubit
                                            .loadTaskDetails();
                                      }
                                    },
                                    child: const Text('Create Timer'),
                                  ),
                                ),
                              ],
                            )
                          else
                            BlocProvider<ExpansionListCubit>(
                              create: (context) => ExpansionListCubit()
                                ..updateList(
                                  activeTimesheets.map((e) => true).toList(),
                                ),
                              child:
                                  BlocBuilder<ExpansionListCubit, List<bool>>(
                                builder: (context, expansionListState) =>
                                    ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: activeTimesheets.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: kPadding.h,
                                  ),
                                  itemBuilder: (context, index) {
                                    final timesheetWithExternalData =
                                        activeTimesheets[index];
                                    final timesheet =
                                        timesheetWithExternalData.timesheet;
                                    final elapsedTime = timesheet.elapsedTime;
                                    final backendId =
                                        externalProject?.backendId;

                                    return TimesheetExpansionTile(
                                      key: ValueKey(
                                        timesheet.id,
                                      ),
                                      initiallyExpanded:
                                          expansionListState[index],
                                      timesheet: timesheet,
                                      onExpansionChanged: (p0) {
                                        context
                                            .read<ExpansionListCubit>()
                                            .updateValue(index, p0);
                                      },
                                      // TODO fix this
                                      subtitle: TaskTimer.large(
                                        key: ValueKey(
                                          [
                                            TimesheetStatusEnum.initial,
                                          ].contains(timesheet.currentStatus),
                                        ),
                                        disabled: syncState.isSyncing,
                                        elapsedTime: elapsedTime,
                                        initialTimerStatus:
                                            timesheet.currentStatus,
                                        onTimerResume: (context) {
                                          final currentlyElapsedTime =
                                              timesheet.elapsedTime;
                                          context
                                              .read<TimerCubit>()
                                              .elapsedTime = Duration(
                                            seconds: currentlyElapsedTime,
                                          );
                                        },
                                        onTimerStateChange: (timercontext,
                                            timerState,
                                            tickDurationInSeconds) async {
                                          final taskDetailsCubit =
                                              context.read<TaskDetailsCubit>();

                                          final isRunning = timerState.status ==
                                              TimesheetStatusEnum.running;
                                          final updatableSeconds = (isRunning
                                              ? tickDurationInSeconds
                                              : 0);
                                          final startTimeValue = (isRunning &&
                                                  timesheet.startTime == null)
                                              ? DateTime.now()
                                              : timesheet.startTime;

                                          final lastTickedValue = isRunning
                                              ? DateTime.now()
                                              : timesheet.lastTicked;
                                          Timesheet updatableTimesheet =
                                              timesheet.copyWith(
                                            unitAmount: Value(
                                                (elapsedTime + updatableSeconds)
                                                    .toUnitAmount()),
                                            currentStatus: timerState.status,
                                            startTime: Value(startTimeValue),
                                            lastTicked: Value(lastTickedValue),
                                          );
                                          await taskDetailsCubit
                                              .updateTimesheet(
                                                  updatableTimesheet);

                                          // update task locally in task list cubit

                                          if (timerState.status ==
                                                  TimesheetStatusEnum.stopped &&
                                              context.mounted) {
                                            await _onTimerStopped(
                                              context: context,
                                              updatableTimesheet:
                                                  updatableTimesheet,
                                              backendId: backendId,
                                              externalTask: externalTask,
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          SizedBox(
                            height: kPadding.h,
                          ),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, authState) {
                              if (timesheets.isNotEmpty &&
                                  externalProject?.backendId != null &&
                                  timesheets.any(
                                    (element) =>
                                        element.externalTimesheet == null,
                                  )) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: kPadding.h * 2,
                                    ),
                                    const Text(
                                      'There are some timesheets that are not synced',
                                    ),
                                    SizedBox(
                                      height: kPadding.h * 2,
                                    ),
                                    if (!syncState.isSyncing)
                                      LinearProgressBuilder(
                                        action: (_) async {
                                          final syncCubit =
                                              context.read<SyncCubit>();

                                          final localTimesheets = state
                                              .timesheets
                                              .where((element) =>
                                                  element.externalTimesheet ==
                                                  null)
                                              .map((e) => e.timesheet)
                                              .toList();

                                          await syncCubit
                                              .uploadTimesheetsToBackend(
                                            externalProject!.backendId!,
                                            localTimesheets,
                                          );
                                        },
                                        onError: (error) async {
                                          if (error is RecordNotFoundError) {
                                            final taskDetailsCubit = context
                                                .read<TaskDetailsCubit>();
                                            final router = context.router;
                                            final notFoundModel = error.model;
                                            if ([projectModel, taskModel]
                                                .contains(notFoundModel)) {
                                              final result =
                                                  await _showOdooRecordDeletedAction(
                                                context,
                                                title:
                                                    '${projectModel == notFoundModel ? 'Project' : 'Task'} was deleted from Odoo!',
                                              );
                                              if (result != null) {
                                                if (notFoundModel ==
                                                    projectModel) {
                                                  switch (result) {
                                                    case _TaskStopAction
                                                          .keepLocally:
                                                      await taskDetailsCubit
                                                          .deleteExternalProject();
                                                      await taskDetailsCubit
                                                          .deleteExternalTask();
                                                      await taskDetailsCubit
                                                          .deleteExternalTimesheets();
                                                      taskDetailsCubit
                                                          .loadTaskDetails();
                                                      break;
                                                    case _TaskStopAction.delete:
                                                      await taskDetailsCubit
                                                          .deleteProject();
                                                      router.pop();
                                                      break;
                                                    default:
                                                  }
                                                } else {
                                                  switch (result) {
                                                    case _TaskStopAction
                                                          .keepLocally:
                                                      await taskDetailsCubit
                                                          .deleteExternalTask();
                                                      await taskDetailsCubit
                                                          .deleteExternalTimesheets();
                                                      taskDetailsCubit
                                                          .loadTaskDetails();
                                                      break;
                                                    case _TaskStopAction.delete:
                                                      await taskDetailsCubit
                                                          .deleteTask();
                                                      router.pop();
                                                      break;
                                                    default:
                                                  }
                                                }
                                              }
                                            } else {
                                              throw error;
                                            }
                                          } else {
                                            throw error;
                                          }
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
                                          key: const ValueKey('syncButton'),
                                          width: double.infinity,
                                          child: OutlinedButton.icon(
                                            icon: const Icon(
                                              CupertinoIcons.arrow_2_circlepath,
                                            ),
                                            onPressed: () async {
                                              if (externalTask == null ||
                                                  externalProject == null) {
                                                final result =
                                                    await _showActionSheet(
                                                  context,
                                                  actions: [
                                                    _TaskStopAction
                                                        .mergeWithSyncedProject
                                                  ],
                                                  title: 'Unable to sync!',
                                                  message:
                                                      'Task or project is not synced yet',
                                                );
                                                if (result != null &&
                                                    result ==
                                                        _TaskStopAction
                                                            .mergeWithSyncedProject) {
                                                  if (context.mounted) {
                                                    await _mergeWithSyncedProject(
                                                      context,
                                                      timesheets
                                                          .first.timesheet,
                                                      externalProject
                                                          ?.backendId,
                                                      externalTask,
                                                    );
                                                  }
                                                }
                                              } else {
                                                action?.call();
                                              }
                                            },
                                            label: const Text(
                                              'Sync timesheets with Odoo',
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (syncState.isSyncing)
                                      SizedBox(
                                        width: double.infinity,
                                        key: const ValueKey(
                                            'syncSkeletonButton'),
                                        child: Skeletonizer(
                                          enabled: true,
                                          // containersColor: Colors.black,
                                          child: ElevatedButton.icon(
                                            onPressed: null,
                                            label: const Skeleton.keep(
                                              child: Text(
                                                'Syncing',
                                              ),
                                            ),
                                            icon: Skeleton.keep(
                                              child: Lottie.asset(
                                                Assets.animationSyncing,
                                                height: kPadding.h * 2.8,
                                                width: kPadding.h * 2.8,
                                                repeat: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: kPadding.h,
                                    ),
                                  ],
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: kPadding.w * 2,
                              vertical: kPadding.h,
                            ),
                            child: Text(
                              'Completed timesheets',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          // if (timesheets.isEmpty)
                          // const EmptyPlaceholder(
                          //   message: 'Completed timesheets will appear here!',
                          // )
                          // else
                          _TimesheetListView(
                            key: ValueKey(timesheets),
                            timesheets: timesheets,
                            isSyncing: syncState.isSyncing,
                            backendId: externalProject?.backendId,
                          ),
                        ],
                      ),
                      if (syncState.isSyncing)
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            );

            return body;
          },
        ),
      );

  /// Sync task with Odoo or locally, depending on `backendId` value
  Future<void> _syncTimesheet({
    required BuildContext context,
    required Timesheet timesheet,
    // if backendId is available then also try to sync with odoo as well as save locally.
    int? backendId,
  }) async {
    final taskDetailsCubit = context.read<TaskDetailsCubit>();
    final syncCubit = context.read<SyncCubit>();

    if (timesheet.startTime == null || timesheet.lastTicked == null) {
      throw Exception('Timer was not started');
    }
    try {
      await taskDetailsCubit.stopWorkingOnTimesheet(timesheet.id);
    } catch (e) {
      rethrow;
    }
    try {
      if (backendId != null) {
        await syncCubit.uploadTimesheetToBackend(timesheet.id, backendId);
      }

      if (context.mounted) {
        AppDialog.showSuccessDialog(
          context: context,
          title: 'Timesheet submitted',
          content:
              'Your timesheet has been successfully ${backendId == null ? 'saved locally' : 'uploaded to your Odoo account'}.',
        );
      }
      taskDetailsCubit.loadTaskDetails();
    } catch (e) {
      if (e is OdooRepositoryException) {
        if (context.mounted) {
          AppDialog.showSuccessDialog(
            context: context,
            title: 'Timesheet submitted',
            content: 'Your timesheet has been successfully saved locally.',
          );
        }
        if (e is RecordNotFoundError && context.mounted) {
          final taskDetailsCubit = context.read<TaskDetailsCubit>();
          final router = context.router;
          final notFoundModel = e.model;
          if ([projectModel, taskModel].contains(notFoundModel)) {
            final result = await _showOdooRecordDeletedAction(
              context,
              title:
                  '${projectModel == notFoundModel ? 'Project' : 'Task'} was deleted from Odoo!',
            );
            if (result != null) {
              if (notFoundModel == projectModel) {
                switch (result) {
                  case _TaskStopAction.keepLocally:
                    await taskDetailsCubit.deleteExternalProject();
                    await taskDetailsCubit.deleteExternalTask();
                    await taskDetailsCubit.deleteExternalTimesheets();
                    taskDetailsCubit.loadTaskDetails();
                    break;
                  case _TaskStopAction.delete:
                    await taskDetailsCubit.deleteProject();
                    router.pop();
                    break;
                  default:
                }
              } else {
                switch (result) {
                  case _TaskStopAction.keepLocally:
                    await taskDetailsCubit.deleteExternalTask();
                    await taskDetailsCubit.deleteExternalTimesheets();
                    taskDetailsCubit.loadTaskDetails();
                    break;
                  case _TaskStopAction.delete:
                    await taskDetailsCubit.deleteTask();
                    router.pop();
                    break;
                  default:
                }
              }
            }
          } else {
            rethrow;
          }
        }
        await taskDetailsCubit.loadTaskDetails(showLoading: false);
      }

      throw Exception('Failed to sync. But changes were saved locally.');
    }
  }

  Future<_TaskStopAction?> _showOdooRecordDeletedAction(BuildContext context,
          {required String title}) =>
      _showActionSheet(
        context,
        title: title,
        message:
            'You can always merge local project and task with synced project later on.',
        actions: [
          _TaskStopAction.keepLocally,
          _TaskStopAction.delete,
        ],
      );

  Future<_TaskStopAction?> _showActionSheet(BuildContext context,
          {required List<_TaskStopAction> actions,
          required String title,
          String? message}) =>
      showCupertinoModalPopup<_TaskStopAction?>(
        context: context,
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        builder: (BuildContext context) => CupertinoTheme(
          data: const CupertinoThemeData(
            barBackgroundColor: CupertinoColors.systemBlue,
          ),
          child: CupertinoActionSheet(
            title: Text(
              title,
              style: const TextStyle(color: CupertinoColors.label),
            ),
            message: message != null
                ? Text(
                    message,
                    style: const TextStyle(
                      color: CupertinoColors.secondaryLabel,
                    ),
                  )
                : null,
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                context.router.pop(_TaskStopAction.cancel);
              },
              child: const Text('Cancel'),
            ),
            actions: <CupertinoActionSheetAction>[
              ...actions
                  .map(
                    (e) => CupertinoActionSheetAction(
                      onPressed: () {
                        context.router.pop(e);
                      },
                      child: Text(e.label),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      );
  Future<void> _onTimerStopped({
    required BuildContext context,
    required Timesheet updatableTimesheet,
    int? backendId,
    ExternalTask? externalTask,
  }) async {
    final taskDetailsCubit = context.read<TaskDetailsCubit>();

    final odooBackends = context
        .read<AuthCubit>()
        .state
        .connectedBackends
        .getBackendsFilteredByType(BackendTypeEnum.odoo);
    if (odooBackends.isNotEmpty && backendId != null && externalTask != null) {
      _syncTimesheet(
        context: context,
        timesheet: updatableTimesheet,
        backendId: backendId,
      );
    } else {
      final result = await _showActionSheet(
        context,
        title: 'Timesheet is not synchronized',
        actions: [
          _TaskStopAction.mergeWithSyncedProject,
          _TaskStopAction.saveLocally,
        ],
      );
      if (result == null || result == _TaskStopAction.cancel) {
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
      } else if (result == _TaskStopAction.mergeWithSyncedProject) {
        if (context.mounted) {
          await _mergeWithSyncedProject(
            context,
            updatableTimesheet,
            backendId,
            externalTask,
          );
        }
      }
    }
  }

  Future _mergeWithSyncedProject(
      BuildContext context,
      Timesheet currentTimesheet,
      int? backendId,
      ExternalTask? externalTask) async {
    final taskDetailsCubit = context.read<TaskDetailsCubit>();
    final router = context.router;
    final updatableTimesheet = currentTimesheet.copyWith(
      currentStatus: TimesheetStatusEnum.paused,
    );
    await taskDetailsCubit.updateTimesheet(updatableTimesheet);
    // Need to write logic for merging task to odoo
    final oldTaskId = updatableTimesheet.taskId;
    final oldProjectId = updatableTimesheet.projectId;
    final didUpdateTask = await router.push(
      TimesheetRouter(
        children: [
          TimesheetMergeRoute(
            timesheet: updatableTimesheet,
          ),
        ],
      ),
    );
    if (context.mounted && didUpdateTask != null) {
      final latestTimesheet =
          await taskDetailsCubit.getTimesheetById(updatableTimesheet.id);
      if (latestTimesheet == null ||
          latestTimesheet.taskId == null && latestTimesheet.projectId != null) {
        throw Exception(
          'Timesheet is empty or does not have a valid task',
        );
      }
      if (oldProjectId != null && oldTaskId != null) {
        await taskDetailsCubit.updateTimesheetsProjectAndTaskIds(
          oldProjectId: oldProjectId,
          oldTaskId: oldTaskId,
          updatedProjectId: latestTimesheet.projectId!,
          updatedTaskId: latestTimesheet.taskId!,
        );
      }

      // final lastestTaskWithProjectExternalData =
      //     await taskDetailsCubit.getTaskWithProjectExternalDataByTaskId(
      //   latestTimesheet.taskId!,
      // );
      // final backendId = lastestTaskWithProjectExternalData
      //     .projectWithExternalData.externalProject?.backendId;
      // if (backendId == null) {
      //   throw Exception('Project is not synced yet');
      // }
      if (context.mounted) {
        await _syncTimesheet(
          context: context,
          timesheet: latestTimesheet,
          // backendId: backendId,
        );

        // debugPrint(
        //     'updated timesheet $didUpdateTask ${latestTimesheet.id}');
        taskDetailsCubit.taskIdValue = latestTimesheet.taskId!;
        taskDetailsCubit.loadTaskDetails(
          showLoading: true,
        );
      }
    }
  }
}

enum _TaskStopAction {
  mergeWithSyncedProject(label: 'Merge with Synced Project'),
  cancel(label: 'Cancel'),
  saveLocally(label: 'Save locally'),
  keepLocally(label: 'Keep locally only'),
  delete(label: 'Delete');

  final String label;
  const _TaskStopAction({required this.label});
}

class _TimesheetListView extends StatelessWidget {
  const _TimesheetListView({
    super.key,
    required this.timesheets,
    required this.isSyncing,
    this.backendId,
  });
  final List<TimesheetExternalData> timesheets;
  final bool isSyncing;
  final int? backendId;

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

          return TimesheetExpansionTile(
            key: ValueKey(timesheet.id),
            timesheet: timesheet,
            leading: Icon(
              externalTimesheet == null || externalTimesheet.externalId == null
                  ? CupertinoIcons.cloud_upload_fill
                  : CupertinoIcons.check_mark_circled_solid,
              size: 32,
            ),
            trailing: Container(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: AppColors.getTintedSurfaceColor(
                    Theme.of(context).colorScheme.surfaceTint),
                borderRadius: BorderRadius.circular(kPadding.r * 8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: kPadding.w * 2,
                vertical: kPadding.h,
              ),
              child: Text(
                Duration(
                  seconds: ((timesheet.unitAmount ?? 0.0) * 3600).toInt(),
                ).timerString(
                  DurationFormat.hoursMinutesSeconds,
                ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          );
        },
      );
}

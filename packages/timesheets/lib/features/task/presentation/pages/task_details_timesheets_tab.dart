import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage(
  name: 'TaskDetailsTimesheetsTab',
)
class TaskDetailsTimesheetsTabPage extends StatelessWidget {
  const TaskDetailsTimesheetsTabPage({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<TimesheetRelationalListCubit>(
            create: (context) => TimesheetRelationalListCubit(
              context.read<TimesheetRelationalRepository>(),
            )..load(
                TimesheetListFilter(
                  taskId: context.router.routeData.pathParams.getInt('taskId'),
                  activeOnly: false,
                ),
              ),
          ),
          BlocProvider<_ActiveTimesheetRelationalListCubit>(
            create: (context) => _ActiveTimesheetRelationalListCubit(
              context.read<TimesheetRelationalRepository>(),
            )..load(
                TimesheetListFilter(
                  activeOnly: true,
                  taskId: context.router.routeData.pathParams.getInt('taskId'),
                ),
              ),
          ),
        ],
        child: BlocBuilder<TaskRelationalDataCubit, TaskDataState>(
          builder: (context, state) {
            final task = state.data;

            Widget body;

            if (state is Loading) {
              body = const Center(
                child: ParticleLoadingIndicator(),
              );
            } else if (state is Empty || task == null) {
              body = const Center(
                child: Text('Task not found'),
              );
            }

            body = ParticleRefreshIndicator(
              onRefresh: () async {
                final taskDetailsCubit =
                    context.read<TaskRelationalDataCubit>();
                final timesheetCubit =
                    context.read<TimesheetRelationalListCubit>();
                final activeTimesheetCubit =
                    context.read<_ActiveTimesheetRelationalListCubit>();

                await Future.wait([
                  taskDetailsCubit.load(),
                  timesheetCubit.reload(),
                  activeTimesheetCubit.reload(),
                ]);
              },
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: kPadding.h * 2,
                      vertical: kPadding.h * 3,
                    ),
                    children: [
                      if (task != null) _ActiveTimeSheetBlocBuilder(task: task),
                      SizedBox(
                        height: kPadding.h,
                      ),
                      BlocConsumer<TimesheetRelationalListCubit,
                          TimesheetListState>(
                        listenWhen: (previous, current) =>
                            previous.data != current.data,
                        listener: (context, state) {
                          final ids = state.data?.map((e) => e.id).toList();
                          if (ids != null) {
                            context
                                .read<SyncCubit<TimesheetModel>>()
                                .loadPendingSyncRegistries(
                                  ids: ids,
                                );
                          }
                        },
                        builder: (context, state) {
                          final timesheets = state.data ?? [];
                          final Widget child;
                          if (timesheets.isEmpty) {
                            child = EmptyPlaceholder(
                              title: 'No completed timesheets',
                              message: 'Completed timesheets will appear here!',
                              icon: DecoratedSvgImage(
                                image: Assets.iconsClock,
                                height: 96.h,
                                width: 96.h,
                              ),
                            );
                          } else {
                            child = _TimesheetListView(
                              key: ValueKey(timesheets),
                              timesheets: timesheets,
                            );
                          }
                          return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              const _SyncTimesheetsWidget(),
                              SizedBox(
                                height: kPadding.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: kPadding.h,
                                ),
                                child: Text(
                                  'Completed timesheets',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              child,
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );

            return body;
          },
        ),
      );
}

class _TimesheetListView extends StatelessWidget {
  const _TimesheetListView({
    super.key,
    required this.timesheets,
  });
  final List<TimesheetModel> timesheets;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SyncCubit<TimesheetModel>, SyncState>(
        builder: (context, state) => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: timesheets.length,
          separatorBuilder: (context, index) => SizedBox(
            height: kPadding.h,
          ),
          itemBuilder: (context, index) {
            final timesheet = timesheets[index];

            return TimesheetExpansionTile(
              key: ValueKey(timesheet.id),
              timesheet: timesheet,
              leading: Icon(
                state.pendingSyncRecordIds?.contains(timesheet.id) == true
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
        ),
      );
}

class _ActiveTimeSheetBlocBuilder extends StatelessWidget {
  const _ActiveTimeSheetBlocBuilder({required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<_ActiveTimesheetRelationalListCubit, TimesheetListState>(
        builder: (context, state) {
          if (state is Loading) {
            return const ParticleLoadingIndicator();
          } else if (state is Empty ||
              state.data == null ||
              state.data!.isEmpty) {
            return Column(
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
                          context.read<TaskRelationalDataCubit>();
                      final activeTimesheetListCubit =
                          context.read<_ActiveTimesheetRelationalListCubit>();
                      final result = await context.router.push(
                        TimesheetRouter(children: [
                          TimesheetAddRoute(
                            disableProjectTaskSelection: false,
                            task: task,
                          ),
                        ]),
                      );
                      if (result != null && result is bool && result) {
                        await taskDetailsCubit.load();
                        await activeTimesheetListCubit.load(
                          activeTimesheetListCubit.state.filter?.copyWith(
                            offset: 0,
                          ),
                        );
                      }
                    },
                    child: const Text('Create Timer'),
                  ),
                ),
              ],
            );
          } else {
            final activeTimesheets = state.data ?? [];
            return BlocProvider<ExpansionListCubit>(
              create: (context) => ExpansionListCubit()
                ..updateList(
                  activeTimesheets.map((e) => true).toList(),
                ),
              child: BlocBuilder<ExpansionListCubit, List<bool>>(
                builder: (context, expansionListState) => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeTimesheets.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: kPadding.h,
                  ),
                  itemBuilder: (context, index) {
                    final timesheet = activeTimesheets[index];

                    final elapsedTime = timesheet.elapsedTime;

                    return TimesheetExpansionTile(
                      key: ValueKey(
                        timesheet.id,
                      ),
                      initiallyExpanded: expansionListState[index],
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
                            TimerStatus.initial,
                          ].contains(timesheet.currentStatus),
                        ),
                        // TODO add logic to disable while syncing
                        disabled: false,
                        elapsedTime: elapsedTime,
                        initialTimerStatus: timesheet.currentStatus,
                        onTimerResume: (context) {
                          final currentlyElapsedTime = timesheet.elapsedTime;
                          context.read<TimerCubit>().elapsedTime = Duration(
                            seconds: currentlyElapsedTime,
                          );
                        },
                        onTimerStateChange: (timercontext, timerState,
                            tickDurationInSeconds) async {
                          final timesheetListCubit = context
                              .read<_ActiveTimesheetRelationalListCubit>();
                          final effectiveTimeSheet =
                              timesheetListCubit.state.data?.firstWhere(
                                  (element) => element.id == timesheet.id);

                          final isRunning =
                              timerState.status == TimerStatus.running;
                          final lastTickedValue = isRunning
                              ? DateTime.timestamp()
                              : effectiveTimeSheet!.lastTicked;

                          // Calculate the newly elapsed time
                          final newlyElapsedSeconds = tickDurationInSeconds;

                          // Add the newly elapsed time to the last recorded unitAmount
                          final updatedUnitAmount =
                              (effectiveTimeSheet!.unitAmount ?? 0) +
                                  newlyElapsedSeconds.toUnitAmount();
                          logger.d(
                              'newlyElapsedSeconds: ${DateTime.timestamp().difference(lastTickedValue!).inSeconds}');
                          TimesheetModel updatableTimesheet =
                              effectiveTimeSheet.copyWith(
                            unitAmount: updatedUnitAmount,
                            currentStatus: timerState.status,
                            lastTicked: lastTickedValue,
                          );
                          logger.d(
                              'Updating timesheet: ${updatableTimesheet.unitAmount}');

                          final updatedTimesheet = await timesheetListCubit
                              .updateItem(updatableTimesheet,
                                  shouldUpdateSecondaryOnly: true);
                          logger.d(
                              'Updated timesheet: ${updatedTimesheet.unitAmount}');

                          if (timerState.status == TimerStatus.stopped &&
                              context.mounted) {
                            await _onTimerStopped(
                              context: context,
                              updatableTimesheet: updatableTimesheet,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      );

  Future<void> _onTimerStopped({
    required BuildContext context,
    required TimesheetModel updatableTimesheet,
  }) async {
    final activeTimesheetListCubit =
        context.read<_ActiveTimesheetRelationalListCubit>();
    final timesheetListCubit = context.read<TimesheetRelationalListCubit>();
    await activeTimesheetListCubit.updateItem(updatableTimesheet);

    activeTimesheetListCubit.reload(
      activeTimesheetListCubit.state.filter?.copyWith(
        offset: 0,
      ),
    );
    timesheetListCubit.reload(
      timesheetListCubit.state.filter?.copyWith(
        offset: 0,
      ),
    );
  }
}

class _ActiveTimesheetRelationalListCubit extends TimesheetRelationalListCubit {
  _ActiveTimesheetRelationalListCubit(super.timesheetRelationalRepository);
}

class _SyncTimesheetsWidget extends StatelessWidget {
  const _SyncTimesheetsWidget();

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<SyncCubit<TimesheetModel>, SyncState>(
        listener: (context, state) {
          if (state.status == SyncStatus.syncFailure) {
            DjangoflowAppSnackbar.showError(
              'Failed to sync, please check your internet connectivity.',
            );
          }
        },
        builder: (context, state) {
          if (state.pendingSyncRecordIds == null ||
              state.pendingSyncRecordIds!.isEmpty) {
            return const SizedBox();
          }
          return Column(
            children: [
              SizedBox(
                height: kPadding.h * 2,
              ),
              Text(
                'There are ${state.pendingSyncRecordIds!.length} timesheets that are not synced',
              ),
              SizedBox(
                height: kPadding.h * 2,
              ),
              if (state.status != SyncStatus.syncInProgress)
                LinearProgressBuilder(
                  action: (_) async {
                    final syncCubit = context.read<SyncCubit<TimesheetModel>>();

                    await syncCubit.sync();
                  },
                  builder: (context, action, error) => SizedBox(
                    key: const ValueKey('syncButton'),
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        CupertinoIcons.arrow_2_circlepath,
                      ),
                      onPressed: () async {
                        action?.call();
                      },
                      label: const Text(
                        'Sync timesheets',
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: kPadding.h,
              ),
            ],
          );
        },
      );
}

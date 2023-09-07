import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
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
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          final taskWithProject = state.taskWithProject;

          final timesheets = state.timesheets;
          final activeTimesheets = state.activeTimesheets;

          Widget body;

          if (state.isLoading) {
            body = const Center(
              child: CircularProgressIndicator(),
            );
          } else if (taskWithProject == null) {
            body = const Center(
              child: Text('Task not found'),
            );
          }

          body = Builder(
            builder: (context) => RefreshIndicator(
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
                                    TimesheetsRouter(children: [
                                      TimesheetAddRoute(
                                        disableProjectTaskSelection: true,
                                        taskWithProject: taskWithProject,
                                      ),
                                    ]),
                                  );
                                  if (result != null &&
                                      result is bool &&
                                      result) {
                                    await taskDetailsCubit.loadTaskDetails();
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
                          child: BlocBuilder<ExpansionListCubit, List<bool>>(
                            builder: (context, expansionListState) =>
                                ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: activeTimesheets.length,
                              separatorBuilder: (context, index) => SizedBox(
                                height: kPadding.h,
                              ),
                              itemBuilder: (context, index) {
                                final activeTimesheet = activeTimesheets[index];

                                final elapsedTime = activeTimesheet.elapsedTime;

                                return TimesheetExpansionTile(
                                  key: ValueKey(
                                    activeTimesheet.id,
                                  ),
                                  initiallyExpanded: expansionListState[index],
                                  timesheet: activeTimesheet,
                                  onExpansionChanged: (p0) {
                                    context
                                        .read<ExpansionListCubit>()
                                        .updateValue(index, p0);
                                  },
                                  // TODO fix this
                                  subtitle: Timer.large(
                                    key: ValueKey(
                                      [
                                        TimerStatus.initial,
                                      ].contains(activeTimesheet.timerStatus),
                                    ),
                                    elapsedTime: elapsedTime,
                                    initialTimerStatus:
                                        activeTimesheet.timerStatus,
                                    onTimerResume: (context) {
                                      final currentlyElapsedTime =
                                          activeTimesheet.elapsedTime;
                                      context.read<TimerCubit>().elapsedTime =
                                          Duration(
                                        seconds: currentlyElapsedTime,
                                      );
                                    },
                                    onTimerStateChange: (timercontext,
                                        timerState,
                                        tickDurationInSeconds) async {
                                      final taskDetailsCubit =
                                          context.read<TaskDetailsCubit>();

                                      final isRunning = timerState.status ==
                                          TimerStatus.running;
                                      final updatableSeconds = (isRunning
                                          ? tickDurationInSeconds
                                          : 0);
                                      final startTimeValue = (isRunning &&
                                              activeTimesheet.startTime == null)
                                          ? DateTime.now()
                                          : activeTimesheet.startTime;

                                      final lastTickedValue = isRunning
                                          ? DateTime.now()
                                          : activeTimesheet.lastTicked;
                                      Timesheet updatableTimesheet =
                                          activeTimesheet.copyWith(
                                        unitAmount:
                                            (elapsedTime + updatableSeconds)
                                                .toUnitAmount(),
                                        timerStatus: timerState.status,
                                        startTime: startTimeValue,
                                        lastTicked: lastTickedValue,
                                      );
                                      await taskDetailsCubit
                                          .updateTimesheet(updatableTimesheet);

                                      // update task locally in task list cubit

                                      if (timerState.status ==
                                              TimerStatus.stopped &&
                                          context.mounted) {
                                        await _onTimerStopped(
                                          context: context,
                                          timesheet: updatableTimesheet,
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
                      _TimesheetListView(
                        key: ValueKey(timesheets),
                        timesheets: timesheets,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );

          return body;
        },
      );

  Future<void> _onTimerStopped({
    required BuildContext context,
    required Timesheet timesheet,
  }) async {
    final taskDetailsCubit = context.read<TaskDetailsCubit>();
    if (timesheet.id == null) {
      throw Exception('Timesheet id is null');
    }
    if (timesheet.startTime == null || timesheet.lastTicked == null) {
      throw Exception('Timer was not started');
    }
    try {
      await taskDetailsCubit.stopWorkingOnTimesheet(timesheet.id!);
      if (context.mounted) {
        AppDialog.showSuccessDialog(
          context: context,
          title: 'Timesheet submitted',
          content: 'Your timesheet has been successfully saved locally.',
        );
      }
      taskDetailsCubit.loadTaskDetails();
    } catch (e) {
      rethrow;
    }
  }
}

class _TimesheetListView extends StatelessWidget {
  const _TimesheetListView({
    super.key,
    required this.timesheets,
  });
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

          return TimesheetExpansionTile(
            key: ValueKey(timesheet.id),
            timesheet: timesheet,
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

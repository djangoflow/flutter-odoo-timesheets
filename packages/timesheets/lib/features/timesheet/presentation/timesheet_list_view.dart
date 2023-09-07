import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/timer/timer.dart';

import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetListView<T extends TimesheetWithTaskProjectListCubit>
    extends StatelessWidget {
  const TimesheetListView({
    super.key,
    required this.emptyBuilder,
  });

  final Widget Function(
          BuildContext context, TimesheetWithTaskProjectListCubitState state)
      emptyBuilder;
  @override
  Widget build(BuildContext context) => ContinuousListViewBlocBuilder<T,
          TimesheetWithTaskProject, TimesheetPaginationFilter>(
        emptyBuilder: emptyBuilder,

        // withRefreshIndicator: true,
        loadingBuilder: (context, state) => const SizedBox(),
        itemBuilder: (context, state, index, item) {
          final timesheet = item.timesheet;
          final project = item.taskWithProject?.project;
          final task = item.taskWithProject?.task;
          final elapsedTime = timesheet.elapsedTime;
          final theme = Theme.of(context);

          return AnimateIfVisible(
            key: ValueKey(timesheet.id),
            builder: (context, animation) => FadeTransition(
              opacity: animation,
              child: IconTheme(
                data: theme.iconTheme.copyWith(
                  size: kPadding.r * 2,
                ),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: TimesheetListTile(
                    leadingBarColor: project?.color.toColorFromColorIndex,
                    title: _ListTileItem(
                      icon: InkWell(
                        borderRadius: BorderRadius.circular(kPadding * 1.5),
                        onTap: () {
                          context.read<T>().updateItem(
                                TimesheetWithTaskProject(
                                  timesheet: timesheet.copyWith(
                                    isFavorite:
                                        !(timesheet.isFavorite ?? false),
                                  ),
                                  taskWithProject: item.taskWithProject,
                                ),
                              );
                        },
                        child: _PaddedIcon(
                          icon: Icon(
                            timesheet.isFavorite ?? false
                                ? CupertinoIcons.star_fill
                                : CupertinoIcons.star,
                          ),
                        ),
                      ),
                      text: timesheet.description ?? '',
                      textStyle: theme.textTheme.titleMedium,
                    ),
                    subtitle: Column(
                      children: [
                        SizedBox(
                          height: kPadding.h / 1.5,
                        ),
                        _ListTileItem(
                          icon: const _PaddedIcon(
                            icon: Icon(
                              CupertinoIcons.briefcase,
                            ),
                          ),
                          text: project?.name ?? '',
                          maxLines: 1,
                          // textStyle: const TextStyle(height: 1),
                        ),
                        if (task?.dateDeadline != null) ...[
                          SizedBox(
                            height: kPadding.h / 1.5,
                          ),
                          _ListTileItem(
                            icon: const _PaddedIcon(
                              icon: Icon(
                                CupertinoIcons.time,
                              ),
                            ),
                            text:
                                'Deadline ${task?.dateDeadline!.toDateString()}',
                            textStyle: const TextStyle(height: 1),
                          ),
                        ],
                      ],
                    ),
                    elapsedTime: elapsedTime,
                    initialTimerStatus: timesheet.timerStatus,
                    onTimerStateChange:
                        (context, timerState, tickInterval) async {
                      final timesheetWithTaskExternalListCubit =
                          context.read<T>();
                      final isRunning =
                          timerState.status == TimerStatus.running;
                      final updatableSeconds = (isRunning ? tickInterval : 0);
                      final startTimeValue =
                          (isRunning && timesheet.startTime == null)
                              ? DateTime.now()
                              : timesheet.startTime;

                      final lastTickedValue =
                          isRunning ? DateTime.now() : timesheet.lastTicked;
                      Timesheet updatableTimesheet = timesheet.copyWith(
                        unitAmount:
                            (elapsedTime + updatableSeconds).toUnitAmount(),
                        timerStatus: timerState.status,
                        startTime: startTimeValue,
                        lastTicked: lastTickedValue,
                      );
                      await timesheetWithTaskExternalListCubit.updateItem(
                        TimesheetWithTaskProject(
                          timesheet: updatableTimesheet,
                          taskWithProject: item.taskWithProject,
                        ),
                      );
                    },
                    onTimerResume: (context) {
                      final currentlyElapsedTime = timesheet.elapsedTime;
                      context.read<TimerCubit>().elapsedTime = Duration(
                        seconds: currentlyElapsedTime,
                      );
                    },
                    onTap: () {
                      // context.router.push(
                      //   TasksRouter(
                      //     children: [
                      //       TaskDetailsRouter(taskId: timesheet.taskId),
                      //     ],
                      //   ),
                      // );
                    },
                  ),
                ),
              ),
            ),
          );
        },
        builder: (context, controller, itemBuilder, itemCount) =>
            AnimateIfVisibleWrapper(
          controller: controller,
          child: RefreshIndicator(
            onRefresh: () => context.read<T>().reload(
                  context.read<T>().state.filter?.copyWith(
                        offset: 0,
                      ),
                ),
            child: ListView.separated(
              shrinkWrap: false,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(
                kPadding.h * 2,
              ),
              controller: controller,
              itemBuilder: itemBuilder,
              itemCount: itemCount,
              separatorBuilder: (context, index) => SizedBox(
                height: kPadding.h,
              ),
            ),
          ),
        ),
      );
}

class _ListTileItem extends StatelessWidget {
  const _ListTileItem(
      {required this.text,
      required this.icon,
      this.textStyle,
      this.maxLines = 1});
  final String text;
  final TextStyle? textStyle;
  final Widget icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          Expanded(
            child: Text(
              text,
              maxLines: maxLines,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}

class _PaddedIcon extends StatelessWidget {
  const _PaddedIcon({required this.icon});
  final Icon icon;
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: kPadding.w),
        child: icon,
      );
}

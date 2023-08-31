import 'package:drift/drift.dart' hide Column;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timer/timer.dart';

import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetListView extends StatelessWidget {
  const TimesheetListView({
    super.key,
    required this.timesheetWithTaskExternalListFilter,
    required this.emptyBuilder,
  });
  final TimesheetWithTaskExternalListFilter timesheetWithTaskExternalListFilter;
  final Widget Function(
          BuildContext context, TimesheetWithTaskExternalListState state)
      emptyBuilder;
  @override
  Widget build(BuildContext context) =>
      BlocProvider<TimesheetWithTaskExternalListCubit>(
        create: (context) => TimesheetWithTaskExternalListCubit(
          context.read<TimesheetRepository>(),
        )..load(timesheetWithTaskExternalListFilter),
        child:
            BlocListener<TabbedOrderingFilterCubit, Map<int, OrderingFilter>>(
          listener: (context, state) {
            final tabsRouter = context.tabsRouter;

            final currentFilter = state[tabsRouter.activeIndex];
            context.read<TimesheetWithTaskExternalListCubit>().reload(
                  timesheetWithTaskExternalListFilter.copyWith(
                    orderingFilters: [
                      currentFilter as OrderingFilter<$TimesheetsTable>
                    ],
                  ),
                );
          },
          child: ContinuousListViewBlocBuilder<
              TimesheetWithTaskExternalListCubit,
              TimesheetWithTaskExternalData,
              TimesheetWithTaskExternalListFilter>(
            emptyBuilder: emptyBuilder,
            withRefreshIndicator: true,
            loadingBuilder: (context, state) => const SizedBox(),
            itemBuilder: (context, state, index, item) {
              final timesheet = item.timesheetExternalData.timesheet;
              final project = item
                  .taskWithProjectExternalData.projectWithExternalData.project;
              final task =
                  item.taskWithProjectExternalData.taskWithExternalData.task;
              final elapsedTime = timesheet.elapsedTime;
              final theme = Theme.of(context);

              return IconTheme(
                data: theme.iconTheme.copyWith(
                  size: kPadding.r * 2,
                ),
                child: TimesheetListTile(
                  key: ValueKey(timesheet.id),
                  leadingBarColor: project.color.toColorFromColorIndex,
                  title: _ListTileItem(
                    icon: InkWell(
                      borderRadius: BorderRadius.circular(kPadding * 1.5),
                      onTap: () {},
                      child: _PaddedIcon(
                        icon: Icon(
                          timesheet.isFavorite
                              ? CupertinoIcons.star_fill
                              : CupertinoIcons.star,
                        ),
                      ),
                    ),
                    text: timesheet.name ?? '',
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
                        text: project.name ?? '',
                        maxLines: 2,
                        // textStyle: const TextStyle(height: 1),
                      ),
                      if (task.dateDeadline != null) ...[
                        SizedBox(
                          height: kPadding.h / 1.5,
                        ),
                        _ListTileItem(
                          icon: const _PaddedIcon(
                            icon: Icon(
                              CupertinoIcons.time,
                            ),
                          ),
                          text: 'Deadline ${task.dateDeadline!.toDateString()}',
                          textStyle: const TextStyle(height: 1),
                        ),
                      ],
                    ],
                  ),
                  elapsedTime: elapsedTime,
                  initialTimerStatus:
                      item.timesheetExternalData.timesheet.currentStatus,
                  onTimerStateChange:
                      (context, timerState, tickInterval) async {
                    final timesheetWithTaskExternalListCubit =
                        context.read<TimesheetWithTaskExternalListCubit>();
                    final isRunning =
                        timerState.status == TimesheetStatusEnum.running;
                    final updatableSeconds = (isRunning ? tickInterval : 0);
                    final startTimeValue =
                        (isRunning && timesheet.startTime == null)
                            ? DateTime.now()
                            : timesheet.startTime;

                    final lastTickedValue =
                        isRunning ? DateTime.now() : timesheet.lastTicked;
                    Timesheet updatableTimesheet = timesheet.copyWith(
                      unitAmount: Value(
                          (elapsedTime + updatableSeconds).toUnitAmount()),
                      currentStatus: timerState.status,
                      startTime: Value(startTimeValue),
                      lastTicked: Value(lastTickedValue),
                    );
                    await timesheetWithTaskExternalListCubit.updateTimesheet(
                      updatableTimesheet,
                    );
                  },
                  onTimerResume: (context) {
                    final currentlyElapsedTime = timesheet.elapsedTime;
                    context.read<TimerCubit>().elapsedTime = Duration(
                      seconds: currentlyElapsedTime,
                    );
                  },
                  onTap: () {
                    if (timesheet.taskId != null) {
                      context.router.push(
                        TasksRouter(
                          children: [
                            TaskDetailsRouter(taskId: timesheet.taskId!),
                          ],
                        ),
                      );
                    } else {
                      throw Exception('Task id is null');
                    }
                  },
                ),
              );
            },
            builder: (context, controller, itemBuilder, itemCount) =>
                ListView.separated(
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
      {super.key,
      required this.text,
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
  const _PaddedIcon({super.key, required this.icon});
  final Icon icon;
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: kPadding.w),
        child: icon,
      );
}

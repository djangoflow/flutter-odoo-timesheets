import 'package:auto_animated/auto_animated.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timer/timer.dart';

import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetListView<
        T extends SyncableListCubit<TimesheetModel, TimesheetListFilter>>
    extends StatelessWidget {
  const TimesheetListView({
    super.key,
    required this.emptyBuilder,
  });

  final Widget Function(BuildContext context, TimesheetListState state)
      emptyBuilder;
  @override
  Widget build(BuildContext context) => BlocListener<
          TabbedOrderingFilterCubit<$AnalyticLinesTable>,
          Map<int, OrderingFilter<$AnalyticLinesTable>>>(
        listener: (context, state) {
          final tabsRouter = context.tabsRouter;

          final currentFilter = state[tabsRouter.activeIndex];
          if (currentFilter != null) {
            final cubit = context.read<T>();
            final f = cubit.state.filter;
            // TODO fix this
            // cubit.reload(
            //   f?.copyWith(
            //     orderingFilters: [currentFilter],
            //   ),
            // );
          }
        },
        child: ContinuousListViewBlocBuilder<T, TimesheetModel,
            TimesheetListFilter>(
          emptyBuilder: emptyBuilder,
          // withRefreshIndicator: true,
          loadingBuilder: (context, state) => const SizedBox(),
          itemBuilder: (context, state, index, timesheet) {
            final project = timesheet.project;
            final task = timesheet.task;
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
                          onTap: () async {
                            final cubit = context.read<T>();
                            final updatedItem = await cubit.updateItem(
                              timesheet.copyWith(
                                isFavorite: !timesheet.isFavorite,
                              ),
                              shouldUpdateSecondaryOnly: true,
                            );
                            if (updatedItem.isFavorite == false) {
                              cubit.removeLocally(updatedItem);
                            }
                          },
                          child: _PaddedIcon(
                            icon: Icon(
                              timesheet.isFavorite
                                  ? CupertinoIcons.star_fill
                                  : CupertinoIcons.star,
                            ),
                          ),
                        ),
                        text: timesheet.name,
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
                      initialTimerStatus: timesheet.currentStatus,
                      onTimerStateChange:
                          (context, timerState, tickInterval) async {
                        final timesheetListCubit = context.read<T>();
                        final effectiveTimeSheet = timesheetListCubit.state.data
                            ?.firstWhere(
                                (element) => element.id == timesheet.id);

                        final isRunning =
                            timerState.status == TimerStatus.running;

                        final lastTickedValue = isRunning
                            ? DateTime.timestamp()
                            : effectiveTimeSheet!.lastTicked;

                        // Calculate the newly elapsed time
                        final newlyElapsedSeconds = tickInterval;

                        // Add the newly elapsed time to the last recorded unitAmount
                        final updatedUnitAmount =
                            (effectiveTimeSheet!.unitAmount ?? 0) +
                                newlyElapsedSeconds.toUnitAmount();

                        TimesheetModel updatableTimesheet =
                            effectiveTimeSheet.copyWith(
                          unitAmount: updatedUnitAmount,
                          currentStatus: timerState.status,
                          lastTicked: lastTickedValue,
                        );

                        final updatedTimesheet =
                            await timesheetListCubit.updateItem(
                          updatableTimesheet,
                          shouldUpdateSecondaryOnly: true,
                        );
                      },
                      onTimerResume: (context) {
                        final currentlyElapsedTime = timesheet.elapsedTime;
                        context.read<TimerCubit>().elapsedTime = Duration(
                          seconds: currentlyElapsedTime,
                        );
                        context.read<T>().update(
                              context
                                  .read<T>()
                                  .state
                                  .data!
                                  .map(
                                    (t) => t.id == timesheet.id
                                        ? timesheet.copyWith(
                                            unitAmount: currentlyElapsedTime
                                                .toUnitAmount(),
                                            lastTicked: DateTime.timestamp(),
                                          )
                                        : t,
                                  )
                                  .toList(),
                            );
                      },
                      onTap: () {
                        context.router.push(
                          TasksRouter(
                            children: [
                              TaskDetailsRouter(taskId: timesheet.taskId),
                            ],
                          ),
                        );
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
            child: ParticleRefreshIndicator(
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

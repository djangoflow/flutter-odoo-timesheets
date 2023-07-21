import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/presentation/task_list_tile.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_with_task_external_list_cubit/timesheet_with_task_external_list_cubit.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_with_task_external_list_cubit/timesheet_with_task_external_list_filter.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetListView extends StatelessWidget {
  const TimesheetListView(
      {super.key, required this.timesheetWithTaskExternalListFilter});
  final TimesheetWithTaskExternalListFilter timesheetWithTaskExternalListFilter;
  @override
  Widget build(BuildContext context) => ContinuousListViewBlocBuilder<
          TimesheetWithTaskExternalListCubit,
          TimesheetWithTaskExternalData,
          TimesheetWithTaskExternalListFilter>(
        create: (context) => TimesheetWithTaskExternalListCubit(
          context.read<TimesheetRepository>(),
        )..load(timesheetWithTaskExternalListFilter),
        emptyBuilder: (context, state) => const Center(
          child: Text('No timesheets found'),
        ),
        withRefreshIndicator: true,
        loadingBuilder: (context, state) => const Center(
          child: CircularProgressIndicator(),
        ),
        itemBuilder: (context, state, index, item) {
          final timesheet = item.timesheetExternalData.timesheet;
          final project =
              item.taskWithProjectExternalData.projectWithExternalData.project;
          final elapsedTime = timesheet.elapsedTime;

          return TaskListTile(
            key: ValueKey(timesheet.id),
            title: Text(timesheet.name ?? ''),
            subtitle: Text(project.name ?? ''),
            elapsedTime: elapsedTime,
            initialTimerStatus:
                item.timesheetExternalData.timesheet.currentStatus,
            onTimerStateChange: (context, timerState, tickInterval) async {
              final timesheetWithTaskExternalListCubit =
                  context.read<TimesheetWithTaskExternalListCubit>();
              final isRunning =
                  timerState.status == TimesheetStatusEnum.running;
              final updatableSeconds = (isRunning ? tickInterval : 0);
              final startTimeValue = (isRunning && timesheet.startTime == null)
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
          );
        },
        builder: (context, controller, itemBuilder, itemCount) =>
            ListView.separated(
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
      );
}

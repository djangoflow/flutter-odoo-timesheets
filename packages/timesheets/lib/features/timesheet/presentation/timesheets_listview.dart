import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/presentation/task_list_tile.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_with_task_external_list_cubit/timesheet_with_task_external_list_cubit.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_with_task_external_list_cubit/timesheet_with_task_external_list_filter.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

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
        loadingBuilder: (context, state) => const Center(
          child: CircularProgressIndicator(),
        ),
        itemBuilder: (context, state, index, item) => TaskListTile(
          title: Text(item.timesheetExternalData.timesheet.name ?? ''),
          subtitle: Text(item.taskWithProjectExternalData
                  .projectWithExternalData.project.name ??
              ''),
          initialTimerStatus:
              item.timesheetExternalData.timesheet.currentStatus,
          onTimerStateChange: (context, timerState, tickInterval) async {},
          onTimerResume: (context) {},
        ),
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

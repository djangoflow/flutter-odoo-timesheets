import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_authentication_repository.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';
import 'package:timesheets/features/task/task.dart';

import '../../timesheet/presentation/timesheet_list_tile.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key, required this.taskListFilter});
  final TaskListFilter taskListFilter;

  @override
  Widget build(BuildContext context) => ContinuousListViewBlocBuilder<
          TaskListCubit, TaskWithProjectExternalData, TaskListFilter>(
        create: (context) => TaskListCubit(
          taskRepository: context.read<TaskRepository>(),
          odooTimesheetRepository: context.read<OdooTimesheetRepository>(),
        )..load(taskListFilter),
        withRefreshIndicator: true,
        loadingBuilder: (_, __) => const SizedBox(),
        emptyBuilder: (_, __) => const TimesheetsPlaceHolder(),
        errorBuilder: (_, __) => const Center(
          child: Text('Error occurred!'),
        ),
        loadingItemsCount: 1,
        itemBuilder: (context, state, index, item) {
          final task = item.taskWithExternalData.task;
          return TimesheetListTile(
            key: ValueKey(task.id),
            title: Text(task.name ?? ''),
            subtitle: const Text(
              // Should be timesheet description
              '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            // elapsedTime: elapsedTime,
            // initialTimerStatus: TimesheetStatusEnum
            //     .values[task.status],
            onTap: () {
              context.router.push(
                TaskDetailsRouter(
                  taskId: task.id,
                  children: const [TaskDetailsRoute()],
                ),
              );
            },
            onTimerResume: (context) {
              // context.read<TimerCubit>().elapsedTime =
              //     Duration(
              //   seconds: elapsedTime,
              // );
            },
            onTimerStateChange:
                (context, timerState, tickDurationInSeconds) async {
              // Need to update timesheet
            },
          );
        },
        builder: (context, controller, itemBuilder, itemCount) =>
            ListView.separated(
          padding: EdgeInsets.all(kPadding.h * 2),
          controller: controller,
          itemBuilder: itemBuilder,
          separatorBuilder: (context, index) => SizedBox(
            height: kPadding.h,
          ),
          itemCount: itemCount,
        ),
      );
}

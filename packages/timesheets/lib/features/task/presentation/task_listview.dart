import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

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
          final project = item.projectWithExternalData.project;

          return ListTile(
            key: ValueKey(task.id),
            leading: ColoredBar(
              color: project.color.toColorFromColorIndex,
            ),
            title: Text(task.name ?? ''),
            subtitle: Text(
                'Deadline : ${task.dateDeadline != null ? DateFormat.yMd().format(task.dateDeadline!) : 'Not set'}'),
            onTap: () {
              context.router.push(
                TaskDetailsRouter(
                  taskId: task.id,
                  children: const [TaskDetailsRoute()],
                ),
              );
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

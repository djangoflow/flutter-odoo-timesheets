import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key, required this.emptyBuilder});

  final Widget Function(BuildContext context, TaskListState state) emptyBuilder;

  @override
  Widget build(BuildContext context) => ContinuousListViewBlocBuilder<
          TaskRelationalListCubit, TaskModel, TaskListFilter>(
        withRefreshIndicator: false,
        loadingBuilder: (_, __) => const ParticleLoadingIndicator(),
        emptyBuilder: emptyBuilder,
        errorBuilder: (_, __) => const Center(
          child: Text('Error occurred!'),
        ),
        loadingItemsCount: 1,
        itemBuilder: (context, state, index, task) {
          final project = task.project;

          return ListTile(
            key: ValueKey(task.id),
            leading: ColoredBar(
              color: project?.color.toColorFromColorIndex ??
                  OdooColors.noColor.color,
            ),
            title: Text(task.name),
            subtitle: Text(
                'Deadline : ${task.dateDeadline != null ? DateFormat.yMd().format(task.dateDeadline!) : 'Not set'}'),
            onTap: () {
              context.router.push(
                TaskDetailsRouter(
                  taskId: task.id,
                  children: const [TaskDetailsTabRouter()],
                ),
              );
            },
          );
        },
        builder: (context, controller, itemBuilder, itemCount) =>
            ParticleRefreshIndicator(
          onRefresh: () => context.read<TaskRelationalListCubit>().reload(
                context.read<TaskRelationalListCubit>().state.filter?.copyWith(
                      offset: 0,
                    ),
              ),
          child: ListView.separated(
            padding: EdgeInsets.all(kPadding.h * 2),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller,
            itemBuilder: itemBuilder,
            separatorBuilder: (context, index) => SizedBox(
              height: kPadding.h,
            ),
            itemCount: itemCount,
          ),
        ),
      );
}

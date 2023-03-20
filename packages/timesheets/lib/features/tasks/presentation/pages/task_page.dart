import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/tasks/blocs/active_tasks_cubit.dart';
import 'package:timesheets/features/tasks/presentation/pages/empty_task_list_page.dart';
import 'package:timesheets/features/tasks/presentation/pages/task_list_page.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeTaskState = context.watch<ActiveTaskCubit>().state;
    final activeTasks = activeTaskState.activeTasks;
    final isTasksEmpty = activeTasks.isEmpty;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: kPadding*10,
        title: Padding(
          padding: const EdgeInsets.all(kPadding * 2),
          child: Text(
            'Tasks',
            style: theme.textTheme.headlineLarge,
          ),
        ),
        actions: [
          IconCard(
            child: IconButton(
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kPadding),
                ),
              ),
              icon: const Icon(
                Icons.settings_outlined,
              ),
              onPressed: () {
                context.router.push(const SettingsRouterRoute());
              },
            ),
          ),
          const SizedBox(
            width: kPadding * 2,
          ),
        ],
      ),
      body: isTasksEmpty
          ? const EmptyTaskListPage()
          : TaskListPage(activeTasks: activeTasks),
      floatingActionButton: Card(
        elevation: kPadding / 4,
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(
            kPadding,
          ),
          child: IconButton(
            onPressed: () {
              context.router.push(const CreateTaskRoute());
            },
            icon: Icon(
              CupertinoIcons.plus,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

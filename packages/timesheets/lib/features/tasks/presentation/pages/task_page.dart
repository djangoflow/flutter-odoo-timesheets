import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
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
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(kPadding * 2),
          child: Text(
            'Tasks',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        actions: [
          IconButton(
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
          IconButton(
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kPadding),
              ),
            ),
            icon: const Icon(Icons.add),
            onPressed: () {
              context.router.push(const CreateTaskRoute());
            },
          ),
        ],
      ),
      body: isTasksEmpty
          ? const EmptyTaskListPage()
          : TaskListPage(activeTasks: activeTasks),
    );
  }
}

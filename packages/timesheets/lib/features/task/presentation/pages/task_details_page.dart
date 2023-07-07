import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class TaskDetailsPage extends StatelessWidget with AutoRouteWrapper {
  const TaskDetailsPage({super.key, @pathParam required this.taskId});
  final int taskId;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDataCubit, TasksDataState>(
        builder: (context, state) {
          final task = state.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(task != null ? 'Task ${task.name}' : 'Task details'),
              actions: [
                if (task != null)
                  IconButton(
                    onPressed: () {
                      context.router.push(
                        TaskEditRoute(task: task),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  )
              ],
            ),
            body: state.map(
              (value) => value.data == null
                  ? const Center(
                      child: Text(
                        'No data!',
                      ),
                    )
                  : _TaskDetails(task: value.data!),
              loading: (value) => const Center(
                child: CircularProgressIndicator(),
              ),
              empty: (value) => const Center(
                child: Text(
                  'No data!',
                ),
              ),
              error: (value) => const Center(
                child: Text(
                  'Something went wrong!',
                ),
              ),
            ),
          );
        },
      );

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (context) => TaskDataCubit(context.read<TasksRepository>())
          ..load(
            TaskRetrieveFilter(taskId: taskId),
          ),
        child: this,
      );
}

class _TaskDetails extends StatelessWidget {
  const _TaskDetails({required this.task});
  final Task task;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return ListView(
      children: [
        if (task.description != null)
          _TaskDescription(
            description: task.description!,
          ),
      ],
    );
  }
}

class _TaskDescription extends StatelessWidget {
  const _TaskDescription({super.key, required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.all(kPadding.h * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Description',
            style: textTheme.titleMedium,
          ),
          SizedBox(height: kPadding.h),
          Text(
            description,
          ),
        ],
      ),
    );
  }
}

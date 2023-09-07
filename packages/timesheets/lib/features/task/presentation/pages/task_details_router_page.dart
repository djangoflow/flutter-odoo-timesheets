import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/in_memory_backend/data/repositories/in_memory_task_with_project_repositroy.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage(name: 'TaskDetailsRouter')
class TaskDetailsRouterPage extends AutoRouter implements AutoRouteWrapper {
  final int taskId;
  const TaskDetailsRouterPage({super.key, @pathParam required this.taskId});

  @override
  Widget wrappedRoute(BuildContext context) {
    final backend = context.read<InMemoryBackend>();
    return BlocProvider<TaskDetailsCubit>(
      create: (context) => TaskDetailsCubit(
        taskId: taskId,
        timesheetRepository: InMemoryTimesheetRepository(
          backend: backend,
        ),
        taskWithProjectRepository: InMemoryTaskWithProjectRepository(
          backend: backend,
        ),
      )..loadTaskDetails(),
      child: this,
    );
  }
}

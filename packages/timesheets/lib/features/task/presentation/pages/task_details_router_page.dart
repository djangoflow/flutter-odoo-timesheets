import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage(name: 'TaskDetailsRouter')
class TaskDetailsRouterPage extends AutoRouter implements AutoRouteWrapper {
  final int taskId;
  const TaskDetailsRouterPage({super.key, @pathParam required this.taskId});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider<TaskRelationalDataCubit>(
        create: (context) => TaskRelationalDataCubit(
          context.read<TaskRelationalRepository>(),
        )..load(
            TaskRetrieveFilter(id: taskId),
          ),
        child: this,
      );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/router/router.dart';
import 'package:timesheets/features/tasks/blocs/active_tasks_cubit.dart';

class TasksRouterPage extends StatelessWidget implements AutoRouteWrapper {
  const TasksRouterPage({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<ActiveTaskCubit>(
        create: (context) => ActiveTaskCubit(),
        child: this,
      );
}

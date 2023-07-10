import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage(name: 'TaskDetailsRouter')
class TaskDetailsRouterPage extends AutoRouter with AutoRouteWrapper {
  final int taskId;
  const TaskDetailsRouterPage({super.key, @pathParam required this.taskId});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<TaskDataCubit>(
            create: (context) => TaskDataCubit(context.read<TasksRepository>())
              ..load(
                TaskRetrieveFilter(taskId: taskId),
              ),
          ),
          BlocProvider<TimesheetListCubit>(
            create: (context) =>
                TimesheetListCubit(context.read<TimesheetsRepository>())
                  ..load(
                    TimesheetListFilter(taskId: taskId),
                  ),
          )
        ],
        child: this,
      );
}

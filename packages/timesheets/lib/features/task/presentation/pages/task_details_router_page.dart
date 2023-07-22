import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';

@RoutePage(name: 'TaskDetailsRouter')
class TaskDetailsRouterPage extends AutoRouter with AutoRouteWrapper {
  final int taskId;
  const TaskDetailsRouterPage({super.key, @pathParam required this.taskId});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<TaskDetailsCubit>(
            create: (context) => TaskDetailsCubit(
              taskId: taskId,
              timesheetRepository: context.read<TimesheetRepository>(),
              odooTimesheetRepository: context.read<OdooTimesheetRepository>(),
              taskRepository: context.read<TaskRepository>(),
              projectRepository: context.read<ProjectRepository>(),
              externalTimesheetRepository:
                  context.read<ExternalTimesheetRepository>(),
            )..loadTaskDetails(),
          ),
        ],
        child: this,
      );
}

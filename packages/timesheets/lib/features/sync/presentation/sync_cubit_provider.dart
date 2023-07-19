import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/sync/blocs/sync_cubit/sync_cubit.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';

class SyncCubitProvider extends BlocProvider<SyncCubit> {
  SyncCubitProvider({super.key, required BuildContext context, super.child})
      : super(
          create: (context) => SyncCubit(
            odooProjectRepository: context.read<OdooProjectRepository>(),
            odooTaskRepository: context.read<OdooTaskRepository>(),
            odooTimesheetRepository: context.read<OdooTimesheetRepository>(),
            timesheetRepository: context.read<TimesheetRepository>(),
            taskRepository: context.read<TaskRepository>(),
            projectRepository: context.read<ProjectRepository>(),
          ),
        );
}

import 'package:timesheets/features/tasks/tasks.dart';
import 'package:timesheets/configurations/configurations.dart';

const taskRoutes = [
  AutoRoute(
    path: '',
    page: TaskPage,
    initial: true,
  ),
  AutoRoute(
    path: 'create_odoo_task',
    page: CreateOdooTaskPage,
    guards: [AuthGuard],
  ),
];

import 'package:timesheets/features/tasks/tasks.dart';
import 'package:timesheets/configurations/configurations.dart';

import 'create_task_page.dart';

const taskRoutes = [
  AutoRoute(
    path: '',
    page: TaskPage,
    initial: true,
  ),
  AutoRoute(
    path: 'create_task',
    page: CreateTaskPage,
  ),
];

import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/blocs/task_data_cubit/task_data_filter.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';
import 'package:timesheets/features/task/task.dart';

abstract class TaskWithProjectRepository extends CrudRepository<TaskWithProject,
    TaskPaginationFilter, TaskDataFilter> {}

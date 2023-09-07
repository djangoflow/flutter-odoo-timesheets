import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/blocs/task_data_cubit/task_data_filter.dart';
import 'package:timesheets/features/task/task.dart';

abstract class TaskRepository
    extends CrudRepository<Task, TaskPaginationFilter, TaskDataFilter> {}

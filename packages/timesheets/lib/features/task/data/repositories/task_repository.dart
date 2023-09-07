import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

abstract class TaskRepository
    extends CrudRepository<Task, TaskPaginationFilter> {}

import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/blocs/task_data_cubit/task_data_filter.dart';
import 'package:timesheets/features/task/task.dart';

export 'task_pagination_filter.dart';

typedef TaskListCubitState = Data<List<Task>, TaskPaginationFilter>;

class TaskListCubit
    extends CrudListCubit<Task, TaskPaginationFilter, TaskDataFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  TaskListCubit({required super.repository});
}

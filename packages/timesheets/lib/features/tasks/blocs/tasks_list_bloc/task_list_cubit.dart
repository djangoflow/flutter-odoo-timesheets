import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/tasks/blocs/tasks_list_bloc/task_list_filter.dart';
import 'package:timesheets/features/tasks/tasks.dart';

class TaskListCubit extends ListCubit<Task, TaskListFilter> {
  final TaskRepository _taskRepository;

  TaskListCubit(this._taskRepository) : super(_taskRepository.getTasks);
}

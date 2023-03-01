import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/tasks/tasks.dart';

class TaskListCubit extends ListCubit<Task, TaskListFilter> {
  TaskListCubit(TaskRepository taskRepository) : super(taskRepository.getTasks);
}

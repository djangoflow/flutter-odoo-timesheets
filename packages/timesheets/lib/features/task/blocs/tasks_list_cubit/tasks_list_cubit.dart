import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/data/repositories/tasks_repository.dart';
import 'package:timesheets/utils/utils.dart';
import 'tasks_list_filter.dart';
export 'tasks_list_filter.dart';

typedef TasksListState = Data<List<Task>, TasksListFilter>;

class TasksListCubit extends ListCubit<Task, TasksListFilter>
    with CubitMaybeEmit {
  final TasksRepository tasksRepository;
  TasksListCubit(this.tasksRepository) : super(tasksRepository.getTasks);

  Future<void> createTask(TasksCompanion tasksCompanion) async {
    final taskId = await tasksRepository.createTask(tasksCompanion);
    final task = await tasksRepository.getTaskById(taskId);
    if (state is Empty) {
      emit(
        Data(
          data: [task!],
          filter: state.filter,
        ),
      );
    } else {
      emit(
        state.copyWith(
          data: [
            task!,
            ...state.data!,
          ],
        ),
      );
    }
  }

  Future<void> updateTask(Task task) async {
    await tasksRepository.updateTask(task);
    final updatedTask = await tasksRepository.getTaskById(task.id);
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.id == task.id) updatedTask! else t,
        ],
      ),
    );
  }

  Future<void> deleteTask(Task task) async {
    await tasksRepository.deleteTask(task);
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.id != task.id) t,
        ],
      ),
    );
  }
}

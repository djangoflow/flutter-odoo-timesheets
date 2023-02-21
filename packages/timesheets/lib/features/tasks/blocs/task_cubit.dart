import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/tasks/tasks.dart';

part 'task_state.dart';

part 'task_cubit.freezed.dart';

part 'task_cubit.g.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this._taskRepository) : super(const TaskState.initial());

  final TaskRepository _taskRepository;

  Future<void> loadTasks({
    required int projectId,
  }) async {
    emit(const TaskState.loading());

    try {
      final List<Task> tasks = await _taskRepository.getTasks(
        projectId: projectId,
      );

      emit(TaskState.success(tasks));
    } on OdooRepositoryException catch (e) {
      emit(TaskState.error(e.message));
    } on Exception catch (e) {
      emit(TaskState.error(e.toString()));
    }
  }
}

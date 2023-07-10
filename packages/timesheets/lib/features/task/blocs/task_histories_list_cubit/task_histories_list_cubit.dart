import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

import 'package:timesheets/utils/utils.dart';

import 'task_histories_list_filter.dart';
export 'task_histories_list_filter.dart';

// TODO rename to single case
typedef TasksHistoriesListState
    = Data<List<TaskHistory>, TaskHistoriesListFilter?>;

class TaskHistoriesListCubit
    extends ListCubit<TaskHistory, TaskHistoriesListFilter?>
    with CubitMaybeEmit {
  final TaskHistoriesRepository taskHistoriesRepository;
  TaskHistoriesListCubit(this.taskHistoriesRepository)
      : super(
          ListBlocUtil.listLoader<TaskHistory, TaskHistoriesListFilter?>(
            loader: ([filter]) => taskHistoriesRepository.getTaskHistories(
              filter?.taskId,
            ),
          ),
        );

  Future<void> createTaskHisoty(
      TaskHistoriesCompanion taskHistoriesCompanion) async {
    final taskHistoryId =
        await taskHistoriesRepository.createTaskHistory(taskHistoriesCompanion);
    final taskHistory =
        await taskHistoriesRepository.getTaskHistoryById(taskHistoryId);
    if (taskHistory == null) {
      throw Exception('TaskHistory not found');
    }

    if (state is Empty) {
      emit(
        Data(
          data: [taskHistory],
          filter: state.filter,
        ),
      );
    } else {
      emit(
        state.copyWith(
          data: [
            taskHistory,
            ...state.data!,
          ],
        ),
      );
    }
  }

  Future<void> updateTaskHistory(TaskHistory taskHistory) async {
    await taskHistoriesRepository.updateTaskHistory(taskHistory);
    final updatedTaskHistory =
        await taskHistoriesRepository.getTaskHistoryById(taskHistory.id);
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.id == taskHistory.id) updatedTaskHistory! else t,
        ],
      ),
    );
  }

  Future<void> deleteTask(TaskHistory taskHistory) async {
    await taskHistoriesRepository.deleteTaskHistory(taskHistory);
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.id != taskHistory.id) t,
        ],
      ),
    );
  }
}

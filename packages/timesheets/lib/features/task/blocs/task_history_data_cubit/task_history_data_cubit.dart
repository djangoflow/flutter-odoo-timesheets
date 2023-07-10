import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

import 'task_history_retrieve_filter.dart';

export 'task_history_retrieve_filter.dart';

typedef TaskHistoryDataState = Data<TaskHistory?, TaskHistoryRetrieveFilter>;

class TaskHistoryDataCubit
    extends DataCubit<TaskHistory?, TaskHistoryRetrieveFilter>
    with CubitMaybeEmit {
  final TaskHistoriesRepository taskHistoriesRepository;

  TaskHistoryDataCubit(this.taskHistoriesRepository)
      : super(
          ListBlocUtil.dataLoader<TaskHistory?, TaskHistoryRetrieveFilter>(
            loader: ([filter]) {
              if (filter == null) {
                throw ArgumentError.notNull('taskId');
              }
              return taskHistoriesRepository
                  .getTaskHistoryById(filter.taskHistoryId);
            },
          ),
        );

  Future<void> updateTaskHistory(TaskHistory taskHistory) async {
    await taskHistoriesRepository.updateTaskHistory(taskHistory);
    emit(Data(data: taskHistory, filter: state.filter));
  }

  Future<void> deleteTask(TaskHistory taskHistory) async {
    await taskHistoriesRepository.deleteTaskHistory(taskHistory);
    emit(const Data.empty());
  }

  Future<void> refreshTask() async {
    await load();
  }
}

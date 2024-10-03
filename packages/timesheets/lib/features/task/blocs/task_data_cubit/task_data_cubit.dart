import 'package:list_bloc/list_bloc.dart';

import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

import '../../../sync/blocs/syncable_data_cubit.dart';

typedef TaskDataState = Data<TaskModel, TaskRetrieveFilter>;

class TaskDataCubit extends SyncableDataCubit<TaskModel, TaskRetrieveFilter> {
  final TaskRepository taskRepository;
  TaskDataCubit(this.taskRepository,
      {Future<TaskModel> Function([TaskRetrieveFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.dataLoader<TaskModel, TaskRetrieveFilter>(
                loader: ([filter]) async {
                  final result = await taskRepository.getById(
                    filter!.id,
                    returnOnlySecondary: true,
                  );
                  if (result != null) {
                    return result;
                  } else {
                    throw Exception('Task not found');
                  }
                },
              ),
          taskRepository,
        );
}

class TaskRelationalDataCubit
    extends SyncableDataCubit<TaskModel, TaskRetrieveFilter> {
  final TaskRelationalRepository taskRepository;
  TaskRelationalDataCubit(this.taskRepository,
      {Future<TaskModel> Function([TaskRetrieveFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.dataLoader<TaskModel, TaskRetrieveFilter>(
                loader: ([filter]) async {
                  final result = await taskRepository.getById(
                    filter!.id,
                    returnOnlySecondary: true,
                  );
                  if (result != null) {
                    return result;
                  } else {
                    throw Exception('Task not found');
                  }
                },
              ),
          taskRepository,
        );
}

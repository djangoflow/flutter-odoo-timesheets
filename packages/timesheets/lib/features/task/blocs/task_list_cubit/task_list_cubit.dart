import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/sync/sync.dart';

import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

typedef TaskListState = Data<List<TaskModel>, TaskListFilter>;

class TaskListCubit extends SyncableListCubit<TaskModel, TaskListFilter> {
  final TaskRepository taskRepository;
  TaskListCubit(this.taskRepository,
      {Future<List<TaskModel>> Function([TaskListFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.listLoader<TaskModel, TaskListFilter>(
                loader: ([filter]) => taskRepository.getAll(
                  offset: filter?.offset,
                  limit: filter?.limit,
                  projectId: filter?.projectId,
                  search: filter?.search,
                  returnOnlySecondary: true,
                ),
              ),
          taskRepository,
        );

  @override
  Future<TaskModel> updateItem(TaskModel model,
      {bool shouldUpdateSecondaryOnly = false}) {
    final result = taskRepository.update(
      model,
      onlyUpdateSecondary: shouldUpdateSecondaryOnly,
    );

    return result;
  }
}

class TaskRelationalListCubit
    extends SyncableListCubit<TaskModel, TaskListFilter> {
  final TaskRelationalRepository taskRepository;
  TaskRelationalListCubit(this.taskRepository,
      {Future<List<TaskModel>> Function([TaskListFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.listLoader<TaskModel, TaskListFilter>(
                loader: ([filter]) => taskRepository.getAll(
                  offset: filter?.offset,
                  limit: filter?.limit,
                  projectId: filter?.projectId,
                  search: filter?.search,
                  returnOnlySecondary: true,
                ),
              ),
          taskRepository,
        );

  @override
  Future<TaskModel> updateItem(TaskModel model,
      {bool shouldUpdateSecondaryOnly = false}) {
    final result = taskRepository.update(
      model.copyWith(writeDate: DateTime.timestamp()),
      onlyUpdateSecondary: shouldUpdateSecondaryOnly,
    );

    return result;
  }
}

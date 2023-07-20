import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';

import 'package:timesheets/features/task/data/models/task_with_project_external_data.dart';
import 'package:timesheets/features/task/data/repositories/tasks_repository.dart';
import 'package:timesheets/utils/utils.dart';
import 'tasks_list_filter.dart';
export 'tasks_list_filter.dart';

typedef TaskListState = Data<List<TaskWithProjectExternalData>, TaskListFilter>;

class TaskListCubit
    extends ListCubit<TaskWithProjectExternalData, TaskListFilter>
    with CubitMaybeEmit {
  final TaskRepository taskRepository;
  final OdooTimesheetRepository odooTimesheetRepository;
  TaskListCubit({
    required this.taskRepository,
    required this.odooTimesheetRepository,
  }) : super(
          ListBlocUtil.listLoader<TaskWithProjectExternalData, TaskListFilter>(
            loader: ([filter]) => taskRepository.getPaginatedTasksWithProjects(
              filter?.limit ?? TaskListFilter.kPageSize,
              filter?.offset,
              filter?.projectId,
            ),
          ),
        );

  Future<void> createTaskWithProject(TasksCompanion tasksCompanion,
      ProjectsCompanion projectsCompanion) async {
    final taskId = await taskRepository.createTaskWithProject(
        tasksCompanion, projectsCompanion);
    final task = await taskRepository.getTaskWithProjectById(taskId);
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

  // TODO 1: Add a method to sync all tasks with onlineId from Odoo
  Future<void> syncAllTasksWithOnlineIdFromOdoo() async {
    // final taskWithProjectExternalDataList =
    //     await taskRepository.getAllTasksWithProjects();
    // for (final task in tasks) {
    //   final onlineId = task.onlineId;
    //   if (onlineId != null) {}
    // }
  }

  Future<void> updateTask(Task task) async {
    await taskRepository.update(task);
    final updatedTaskWithProject =
        await taskRepository.getTaskWithProjectById(task.id);
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.taskWithExternalData.task.id == task.id)
              updatedTaskWithProject!
            else
              t,
        ],
      ),
    );
  }

  Future<void> deleteTask(Task task) async {
    await taskRepository.deleteTask(task);
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.taskWithExternalData.task.id != task.id) t,
        ],
      ),
    );
  }

  void updateTaskLocally(Task task) {
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.taskWithExternalData.task.id == task.id)
              t.copyWith(
                taskWithExternalData: t.taskWithExternalData.copyWith(
                  task: task,
                ),
              )
            else
              t,
        ],
      ),
    );
  }
}

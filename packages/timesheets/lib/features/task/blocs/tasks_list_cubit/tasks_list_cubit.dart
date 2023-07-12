import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';

import 'package:timesheets/features/task/data/models/task_with_project.dart';
import 'package:timesheets/features/task/data/repositories/tasks_repository.dart';
import 'package:timesheets/utils/utils.dart';
import 'tasks_list_filter.dart';
export 'tasks_list_filter.dart';

typedef TasksListState = Data<List<TaskWithProject>, TasksListFilter>;

class TasksListCubit extends ListCubit<TaskWithProject, TasksListFilter>
    with CubitMaybeEmit {
  final TasksRepository tasksRepository;
  final OdooTimesheetRepository odooTimesheetRepository;
  TasksListCubit({
    required this.tasksRepository,
    required this.odooTimesheetRepository,
  }) : super(
          ListBlocUtil.listLoader<TaskWithProject, TasksListFilter>(
            loader: ([filter]) => tasksRepository.getTasksWithProjects(
                filter?.limit ?? TasksListFilter.kPageSize, filter?.offset),
          ),
        );

  Future<void> createTaskWithProject(TasksCompanion tasksCompanion,
      ProjectsCompanion projectsCompanion) async {
    final taskId = await tasksRepository.createTaskWithProject(
        tasksCompanion, projectsCompanion);
    final task = await tasksRepository.getTaskWithProjectById(taskId);
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
    final tasks = await tasksRepository.getAllTasks();
    for (final task in tasks) {
      final onlineId = task.onlineId;
      if (onlineId != null) {}
    }
  }

  Future<void> updateTask(Task task) async {
    await tasksRepository.updateTask(task);
    final updatedTaskWithProject =
        await tasksRepository.getTaskWithProjectById(task.id);
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.task.id == task.id) updatedTaskWithProject! else t,
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
            if (t.task.id != task.id) t,
        ],
      ),
    );
  }

  void updateTaskLocally(Task task) {
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.task.id == task.id) t.copyWith(task: task) else t,
        ],
      ),
    );
  }
}

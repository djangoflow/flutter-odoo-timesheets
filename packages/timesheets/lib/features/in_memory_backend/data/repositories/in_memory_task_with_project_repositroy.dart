import 'package:timesheets/features/in_memory_backend/data/repositories/in_memory_task_repository.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/blocs/task_data_cubit/task_data_filter.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';
import 'package:timesheets/features/task/task.dart';

class InMemoryTaskWithProjectRepository implements TaskWithProjectRepository {
  InMemoryTaskWithProjectRepository({required InMemoryBackend backend})
      : taskRepository = InMemoryTaskRepository(backend: backend),
        projectRepository = InMemoryProjectRepository(backend: backend);

  final InMemoryTaskRepository taskRepository;
  final InMemoryProjectRepository projectRepository;

  @override
  Future<TaskWithProject> createItem(TaskWithProject item) async {
    final task = await taskRepository.createItem(item.task);

    return TaskWithProject(
      project: item.project,
      task: task,
    );
  }

  @override
  Future<int> deleteItem(int id) => taskRepository.deleteItem(id);

  @override
  Future<bool> exists(int id) => taskRepository.exists(id);

  @override
  Future<List<TaskWithProject>> getAllItems() =>
      taskRepository.getAllItems().then(_toTaskWithProjectList);

  @override
  Future<TaskWithProject> getItemById([TaskDataFilter? filter]) async {
    final task = await taskRepository.getItemById(filter);

    final project = await projectRepository
        .getItemById(ProjectDataFilter(id: task.projectId));
    return TaskWithProject(
      project: project,
      task: task,
    );
  }

  @override
  Future<List<TaskWithProject>> getPaginatedItems(
      [TaskPaginationFilter? filter]) async {
    final tasks = await taskRepository.getPaginatedItems(filter);
    return _toTaskWithProjectList(tasks);
  }

  @override
  Future<TaskWithProject> updateItem(TaskWithProject item) async {
    final task = item.task;
    final updatedTask = await taskRepository.updateItem(task);
    return item.copyWith(
      task: updatedTask,
    );
  }

  Future<List<TaskWithProject>> _toTaskWithProjectList(
      Iterable<Task> tasks) async {
    final taskWithProjectList = <TaskWithProject>[];
    for (final task in tasks) {
      final project = await projectRepository
          .getItemById(ProjectDataFilter(id: task.projectId));

      taskWithProjectList.add(
        TaskWithProject(
          project: project,
          task: task,
        ),
      );
    }

    return taskWithProjectList;
  }
}

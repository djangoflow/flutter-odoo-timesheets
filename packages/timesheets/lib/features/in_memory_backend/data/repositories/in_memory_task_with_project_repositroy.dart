import 'package:timesheets/features/in_memory_backend/data/repositories/in_memory_task_repository.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';
import 'package:timesheets/features/task/task.dart';

class InMemoryTaskWithProjectRepository implements TaskWithProjectRepository {
  InMemoryTaskWithProjectRepository({required InMemoryBackend backend})
      : taskRepository = InMemoryTaskRepository(backend: backend),
        projectRepository = InMemoryProjectRepository(backend: backend);

  final InMemoryTaskRepository taskRepository;
  final InMemoryProjectRepository projectRepository;

  @override
  Future<int> createItem(TaskWithProject item) {
    final task = item.task;
    return taskRepository.createItem(task);
  }

  @override
  Future<int> deleteItem(int id) => taskRepository.deleteItem(id);

  @override
  Future<bool> exists(int id) => taskRepository.exists(id);

  @override
  Future<List<TaskWithProject>> getAllItems() =>
      taskRepository.getAllItems().then(_toTaskWithProjectList);

  @override
  Future<TaskWithProject?> getItemById(int id) async {
    final task = await taskRepository.getItemById(id);
    Project? project;
    if (task != null) {
      project = await projectRepository.getItemById(task.projectId);
      return TaskWithProject(
        project: project,
        task: task,
      );
    } else {
      return null;
    }
  }

  @override
  Future<List<TaskWithProject>> getPaginatedItems(
      [TaskPaginationFilter? filter]) async {
    final tasks = await taskRepository.getPaginatedItems(filter);
    return _toTaskWithProjectList(tasks);
  }

  @override
  Future<void> updateItem(TaskWithProject item) {
    final task = item.task;
    return taskRepository.updateItem(task);
  }

  Future<List<TaskWithProject>> _toTaskWithProjectList(
      Iterable<Task> tasks) async {
    final taskWithProjectList = <TaskWithProject>[];
    for (final task in tasks) {
      final project = await projectRepository.getItemById(task.projectId);
      if (project != null) {
        taskWithProjectList.add(
          TaskWithProject(
            project: project,
            task: task,
          ),
        );
      }
    }

    return taskWithProjectList;
  }
}

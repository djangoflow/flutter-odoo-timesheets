import 'package:collection/collection.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:uuid/uuid.dart';

class InMemoryProjectRepository implements ProjectRepository {
  final InMemoryBackend _backend;

  InMemoryProjectRepository({required InMemoryBackend backend})
      : _backend = backend;

  @override
  Future<Project> createItem(Project item) {
    const uuid = Uuid();

    // assign id
    final updatedItem = item.copyWith(
      id: uuid.v4().hashCode,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _backend.projects.add(updatedItem);
    // return id
    return Future.value(updatedItem);
  }

  @override
  Future<int> deleteItem(int id) {
    _backend.projects.removeWhere((element) => element.id == id);
    return Future.value(id);
  }

  @override
  Future<List<Project>> getAllItems() => Future.value(_backend.projects);

  @override
  Future<Project> getItemById([ProjectDataFilter? filter]) {
    if (filter == null) {
      throw Exception('DataFilter is null');
    }
    final project = _backend.projects
        .firstWhereOrNull((element) => element.id == filter.id);
    if (project == null) {
      throw Exception('Project not found');
    }
    return Future.value(project);
  }

  @override
  Future<List<Project>> getPaginatedItems(
      [ProjectPaginationFilter? filter]) async {
    final projects = _backend.projects.where((element) {
      if (filter?.search != null && filter!.search!.isNotEmpty) {
        if (element.name == null) {
          return false;
        }
        return element.name!.toLowerCase().contains(
              filter.search!.toLowerCase(),
            );
      }

      return true;
    }).skip(filter?.offset ?? ProjectPaginationFilter.kPageSize);
    if (filter?.limit != null) {
      return projects.take(filter!.limit).toList();
    }
    return projects.toList();
  }

  @override
  Future<void> updateItem(Project item) async {
    final index =
        _backend.projects.indexWhere((element) => element.id == item.id);
    if (index == -1) {
      throw Exception('Item not found');
    }
    _backend.projects[index] = item.copyWith(
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<bool> exists(int id) =>
      Future.value(_backend.projects.any((element) => element.id == id));
}

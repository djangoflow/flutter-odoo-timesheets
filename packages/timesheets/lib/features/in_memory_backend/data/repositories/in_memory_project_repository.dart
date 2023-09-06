import 'package:collection/collection.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:uuid/uuid.dart';

class InMemoryProjectRepository implements ProjectRepository {
  final InMemoryBackend _backend;

  InMemoryProjectRepository({required InMemoryBackend backend})
      : _backend = backend;

  @override
  Future<int> createItem(Project item) {
    const uuid = Uuid();

    // assign id
    final updatedItem = item.copyWith(id: uuid.v4().hashCode);
    _backend.projects.add(updatedItem);
    // return id
    return Future.value(updatedItem.id);
  }

  @override
  Future<int> deleteItem(int id) {
    _backend.projects.removeWhere((element) => element.id == id);
    return Future.value(id);
  }

  @override
  Future<List<Project>> getAllItems() => Future.value(_backend.projects);

  @override
  Future<Project?> getItemById(int id) => Future.value(
        _backend.projects.firstWhereOrNull((element) => element.id == id),
      );

  @override
  Future<List<Project>> getPaginatedItems(
      [ProjectPaginatedFilter? filter]) async {
    final projects = _backend.projects
        .skip(filter?.offset ?? ProjectPaginatedFilter.kPageSize);
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
    _backend.projects[index] = item;
  }
}

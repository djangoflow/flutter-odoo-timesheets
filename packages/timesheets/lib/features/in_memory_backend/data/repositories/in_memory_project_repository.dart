import 'package:collection/collection.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:uuid/uuid.dart';

class InMemoryProjectRepository implements ProjectRepository {
  final List<Project> _projects = [];

  @override
  Future<int> createItem(Project item) {
    const uuid = Uuid();

    // assign id
    final updatedItem = item.copyWith(id: uuid.v4().hashCode);
    _projects.add(updatedItem);
    // return id
    return Future.value(updatedItem.id);
  }

  @override
  Future<int> deleteItem(int id) {
    _projects.removeWhere((element) => element.id == id);
    return Future.value(id);
  }

  @override
  Future<List<Project>> getAllItems() => Future.value(_projects);

  @override
  Future<Project?> getItemById(int id) => Future.value(
        _projects.firstWhereOrNull((element) => element.id == id),
      );

  @override
  Future<List<Project>> getPaginatedItems(
      [ProjectPaginatedFilter? filter]) async {
    final projects =
        _projects.skip(filter?.offset ?? ProjectPaginatedFilter.kPageSize);
    if (filter?.limit != null) {
      return projects.take(filter!.limit).toList();
    }
    return projects.toList();
  }

  @override
  Future<void> updateItem(Project item) async {
    final index = _projects.indexWhere((element) => element.id == item.id);
    if (index == -1) {
      throw Exception('Item not found');
    }
    _projects[index] = item;
  }
}

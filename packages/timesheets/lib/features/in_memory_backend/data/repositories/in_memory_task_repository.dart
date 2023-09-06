import 'package:collection/collection.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:uuid/uuid.dart';

class InMemoryTaskRepository implements TaskRepository {
  final InMemoryBackend _backend;

  InMemoryTaskRepository({required InMemoryBackend backend})
      : _backend = backend;

  @override
  Future<int> createItem(Task item) {
    const uuid = Uuid();

    // assign id
    final updatedItem = item.copyWith(
      id: uuid.v4().hashCode,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _backend.tasks.add(updatedItem);
    // return id
    return Future.value(updatedItem.id);
  }

  @override
  Future<int> deleteItem(int id) {
    _backend.tasks.removeWhere((element) => element.id == id);

    return Future.value(id);
  }

  @override
  Future<List<Task>> getAllItems() => Future.value(_backend.tasks);

  @override
  Future<Task?> getItemById(int id) => Future.value(
        _backend.tasks.firstWhereOrNull((element) => element.id == id),
      );

  @override
  Future<List<Task>> getPaginatedItems([TaskPaginatedFilter? filter]) async {
    final items = _backend.tasks.where((item) {
      if (filter?.projectId != null) {
        return item.projectId == filter!.projectId;
      }
      return true;
    }).skip(filter?.offset ?? TaskPaginatedFilter.kPageSize);
    if (filter?.limit != null) {
      return items.take(filter!.limit).toList();
    }
    return items.toList();
  }

  @override
  Future<void> updateItem(Task item) async {
    final index = _backend.tasks.indexWhere((element) => element.id == item.id);
    if (index == -1) {
      throw Exception('Item not found');
    }
    _backend.tasks[index] = item.copyWith(
      updatedAt: DateTime.now(),
    );
  }
}

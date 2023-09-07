import 'package:collection/collection.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:uuid/uuid.dart';

class InMemoryTimesheetRepository implements TimesheetRepository {
  final InMemoryBackend _backend;

  InMemoryTimesheetRepository({required InMemoryBackend backend})
      : _backend = backend;

  @override
  Future<int> createItem(Timesheet item) {
    const uuid = Uuid();

    // assign id
    final updatedItem = item.copyWith(
      id: uuid.v4().hashCode,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _backend.timesheets.add(updatedItem);
    // return id
    return Future.value(updatedItem.id);
  }

  @override
  Future<int> deleteItem(int id) {
    _backend.timesheets.removeWhere((element) => element.id == id);

    return Future.value(id);
  }

  @override
  Future<List<Timesheet>> getAllItems() => Future.value(_backend.timesheets);

  @override
  Future<Timesheet?> getItemById(int id) => Future.value(
        _backend.timesheets.firstWhereOrNull((element) => element.id == id),
      );

  @override
  Future<List<Timesheet>> getPaginatedItems(
      [TimesheetPaginatedFilter? filter]) async {
    final items = _backend.timesheets.where((item) {
      bool hasMatchedFilter = true;
      if (filter?.projectId != null || filter?.taskId != null) {
        if (filter?.projectId == item.projectId ||
            filter?.taskId == filter?.taskId) {
          hasMatchedFilter = true;
        } else {
          hasMatchedFilter = false;
        }
      }

      return hasMatchedFilter;
    }).skip(filter?.offset ?? TimesheetPaginatedFilter.kPageSize);
    if (filter?.limit != null) {
      return items.take(filter!.limit).toList();
    }
    return items.toList();
  }

  @override
  Future<void> updateItem(Timesheet item) async {
    final index =
        _backend.timesheets.indexWhere((element) => element.id == item.id);
    if (index == -1) {
      throw Exception('Item not found');
    }
    _backend.timesheets[index] = item.copyWith(
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<bool> exists(int id) =>
      Future.value(_backend.timesheets.any((element) => element.id == id));
}

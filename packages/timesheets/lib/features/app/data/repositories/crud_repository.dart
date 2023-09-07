import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';

/// F is the filter type for paginated list of items
/// DF is the filter type for getting a single item by id and other filters if needed
abstract class CrudRepository<T, F extends OffsetLimitFilter,
    DF extends ByIdFilter> {
  Future<List<T>> getPaginatedItems([F? filter]);
  Future<List<T>> getAllItems();
  Future<T> createItem(T item);
  Future<void> updateItem(T item);
  Future<int> deleteItem(int id);
  Future<T> getItemById([DF? filter]);
  Future<bool> exists(int id);
}

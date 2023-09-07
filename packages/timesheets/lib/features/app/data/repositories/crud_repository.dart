import 'package:list_bloc/list_bloc.dart';

abstract class CrudRepository<T, F extends OffsetLimitFilter> {
  Future<List<T>> getPaginatedItems([F? filter]);
  Future<List<T>> getAllItems();
  Future<int> createItem(T item);
  Future<void> updateItem(T item);
  Future<int> deleteItem(int id);
  Future<T?> getItemById(int id);
  Future<bool> exists(int id);
}

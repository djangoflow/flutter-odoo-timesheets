import 'package:drift/drift.dart';

abstract class BaseDao<T, Id> {
  Future<bool> exists(String primaryColumn, Id id);

  /// Return list of paginated data.
  Future<List<T>> page({
    required int limit,
    required int skip,
    List<OrderBy> orderBy = const [],
  });

  /// Return data that is referenced by the given [Id] in the [table].
  Future<T> getById(
    String table,
    String primaryColumn,
    Id id,
  );

  /// Return data that is referenced by the given [key] and the [value].
  Future<List<T>> by(
    String table,
    String key,
    dynamic value,
  );

  /// Store data in the backend and return the newly stored data.
  Future<Map<String, dynamic>> add(
    String table,
    String primaryColumn,
    Map<String, dynamic> data,
  );

  /// Store multiple items in the backend and return the newly stored data.
  Future<List<Map<String, dynamic>>> addAll(
    String table,
    String primaryColumn,
    List<Map<String, dynamic>> data,
  );

  /// Update data in the backend and return the newly updated data.
  Future<Map<String, dynamic>> update(
    String table,
    String primaryColumn,
    Map<String, dynamic> data,
  );

  /// Update multiple items in the backend and return the newly updated data.
  Future<List<Map<String, dynamic>>> updateAll(
    String table,
    String primaryColumn,
    List<Map<String, dynamic>> data,
  );

  /// Remove data in the backend.
  Future<void> remove(
    String table,
    String primaryColumn,
    Map<String, dynamic> data,
  );

  /// Remove multiple items in the backend.
  Future<void> removeAll(
    String table,
    String primaryColumn,
    List<Map<String, dynamic>> data,
  );
}

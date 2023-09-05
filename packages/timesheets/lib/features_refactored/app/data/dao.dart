import 'package:drift/drift.dart';

abstract class Dao<T extends DataClass, C extends UpdateCompanion<T>> {
  Future<int> insertEntity(C insertableEntity);
  Future<bool> updateEntity(T entity);
  Future<int> deleteEntity(int id);
  Future<T?> getById(int id);
  Future<List<T>> getAll();
  Future<List<T>> getPaginatedEntities({
    int? offset,
    int? limit,
    String? search,
  });
}

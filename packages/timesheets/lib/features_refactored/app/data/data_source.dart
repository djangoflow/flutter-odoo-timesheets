abstract class DataSource<T> {
  Future<T?> getById(int id);
  Future<List<T>> getAll();
  Future<int> insert(T entity);
  Future<bool> update(T entity);
  Future<int> delete(int id);
  Future<List<T>> getPaginatedItems({
    int? offset,
    int? limit,
    String? search,
  });
}

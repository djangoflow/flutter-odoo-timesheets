abstract class CrudRepository<M, C> {
  const CrudRepository();
  Future<List<M>> getPaginatedItems({int? offset = 0, int limit = 50});
  Future<List<M>> getItems();
  Future<int> create(C companion);
  Future<void> update(M entity);
  Future<int> delete(M entity);
  Future<M?> getItemById(int id);
}

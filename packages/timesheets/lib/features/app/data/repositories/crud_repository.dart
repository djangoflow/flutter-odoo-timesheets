abstract class CrudRepository<M, C> {
  Future<List<M>> getAll({int? offset = 0, int? limit = 50});
  Future<M> get(String id);
  Future<M> create(C entity);
  Future<M> update(M entity);
  Future<void> delete(M id);
}

import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

class BackendsRepository extends CrudRepository<Backend, BackendsCompanion> {
  final BackendsDao backendsDao;

  const BackendsRepository(this.backendsDao);

  @override
  Future<int> create(BackendsCompanion companion) =>
      backendsDao.createBackend(companion);

  @override
  Future<int> delete(Backend entity) => backendsDao.deleteBackend(entity);

  @override
  Future<Backend?> getItemById(int id) => backendsDao.getBackendById(id);

  @override
  Future<List<Backend>> getItems() => backendsDao.getAllBackends();

  @override
  Future<List<Backend>> getPaginatedItems({int? offset = 0, int limit = 50}) =>
      backendsDao.getPaginatedBackends(limit, offset);

  @override
  Future<void> update(Backend entity) => backendsDao.updateBackend(
        entity.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
}

import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class BackendsRepository {
  final BackendsDao backendsDao;

  BackendsRepository(
    this.backendsDao,
  );

  Future<int> createBackend(BackendsCompanion backend) =>
      backendsDao.createBackend(backend);

  Future<Backend?> getBackendById(int backendId) =>
      backendsDao.getBackendById(backendId);

  Future<List<Backend>> getAllBackends() => backendsDao.getAllBackends();

  Future<void> updateBackend(Backend backend) =>
      backendsDao.updateBackend(backend);

  Future<void> deleteBackend(Backend backend) =>
      backendsDao.deleteBackend(backend);
}

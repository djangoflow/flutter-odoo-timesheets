import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class BackendsRepository {
  final BackendsDao backendsDao;

  const BackendsRepository(
    this.backendsDao,
  );

  Future<int> createBackend(BackendsCompanion backendsCompanion) =>
      backendsDao.createBackend(backendsCompanion.copyWith(
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));

  Future<Backend?> getBackendById(int backendId) =>
      backendsDao.getBackendById(backendId);

  Future<List<Backend>> getAllBackends() => backendsDao.getAllBackends();

  Future<void> updateBackend(Backend backend) => backendsDao.updateBackend(
        backend.copyWith(
          updatedAt: DateTime.now(),
        ),
      );

  Future<void> deleteBackend(Backend backend) =>
      backendsDao.deleteBackend(backend);
}

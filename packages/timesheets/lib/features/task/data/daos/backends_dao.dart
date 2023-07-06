import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

part 'backends_dao.g.dart';

@DriftAccessor(tables: [Backends])
class BackendsDao extends DatabaseAccessor<AppDatabase>
    with _$BackendsDaoMixin {
  BackendsDao(AppDatabase db) : super(db);

  // Backend CRUD operations
  Future<int> createBackend(BackendsCompanion backendsCompanion) =>
      into(backends).insert(backendsCompanion);

  Future<Backend?> getBackendById(int backendId) =>
      (select(backends)..where((b) => b.id.equals(backendId)))
          .getSingleOrNull();

  Future<List<Backend>> getAllBackends() => select(backends).get();

  Future<void> updateBackend(Backend backend) =>
      update(backends).replace(backend);

  Future<void> deleteBackend(Backend backend) =>
      delete(backends).delete(backend);
}

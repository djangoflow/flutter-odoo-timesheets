import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

part 'backends_dao.g.dart';

@DriftAccessor(tables: [Backends])
class BackendsDao extends DatabaseAccessor<AppDatabase>
    with _$BackendsDaoMixin {
  BackendsDao(AppDatabase db) : super(db);

  // CRUD operations for Backends
  Future<int> createBackend(BackendsCompanion backendCompanion) =>
      into(backends).insert(backendCompanion);

  Future<Backend?> getBackendById(int backendId) =>
      (select(backends)..where((b) => b.id.equals(backendId)))
          .getSingleOrNull();

  Future<List<Backend>> getAllBackends() => select(backends).get();

  Future<List<Backend>> getPaginatedBackends(int limit, int? offset) =>
      (select(backends)..limit(limit, offset: offset)).get();

  Future<void> updateBackend(Backend backend) =>
      update(backends).replace(backend);

  Future<int> deleteBackend(Backend backend) =>
      delete(backends).delete(backend);
}

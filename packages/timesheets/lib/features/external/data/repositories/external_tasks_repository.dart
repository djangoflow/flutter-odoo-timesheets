import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

class ExternalTasksRepository
    extends CrudRepository<ExternalTask, ExternalTasksCompanion> {
  final ExternalTasksDao externalTasksDao;

  const ExternalTasksRepository(this.externalTasksDao);

  @override
  Future<int> create(ExternalTasksCompanion companion) =>
      externalTasksDao.createExternalTask(companion);

  @override
  Future<int> delete(ExternalTask entity) =>
      externalTasksDao.deleteExternalTask(entity);

  @override
  Future<ExternalTask?> getItemById(int id) =>
      externalTasksDao.getExternalTaskById(id);

  @override
  Future<List<ExternalTask>> getItems() =>
      externalTasksDao.getAllExternalTasks();

  @override
  Future<List<ExternalTask>> getPaginatedItems(
          {int? offset = 0, int limit = 50}) =>
      externalTasksDao.getPaginatedExternalTasks(limit, offset);

  @override
  Future<void> update(ExternalTask entity) =>
      externalTasksDao.updateExternalTask(
        entity.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
}

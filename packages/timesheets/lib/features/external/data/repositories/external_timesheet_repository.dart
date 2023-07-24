import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

class ExternalTimesheetRepository
    extends CrudRepository<ExternalTimesheet, ExternalTimesheetsCompanion> {
  final ExternalTimesheetsDao externalTimesheetsDao;

  const ExternalTimesheetRepository(this.externalTimesheetsDao);

  @override
  Future<int> create(ExternalTimesheetsCompanion companion) =>
      externalTimesheetsDao.createExternalTimesheet(companion);

  @override
  Future<int> delete(ExternalTimesheet entity) =>
      externalTimesheetsDao.deleteExternalTimesheet(entity);

  @override
  Future<ExternalTimesheet?> getItemById(int id) =>
      externalTimesheetsDao.getExternalTimesheetById(id);

  @override
  Future<List<ExternalTimesheet>> getItems() =>
      externalTimesheetsDao.getAllExternalTimesheets();

  @override
  Future<List<ExternalTimesheet>> getPaginatedItems(
          {int? offset = 0, int limit = 50}) =>
      externalTimesheetsDao.getPaginatedExternalTimesheets(limit, offset);

  @override
  Future<void> update(ExternalTimesheet entity) => externalTimesheetsDao
      .updateExternalTimesheet(entity.copyWith(updatedAt: DateTime.now()));

  Future<List<ExternalTimesheet>> getExternalTimesheetsByInternalIds(
          List<int> internalIds) =>
      externalTimesheetsDao.getExternalTimesheetsByInternalIds(internalIds);

  Future<void> batchDeleteExternalTimesheetsByIds(List<int> ids) =>
      externalTimesheetsDao.batchDeleteExternalTimesheets(ids);
}

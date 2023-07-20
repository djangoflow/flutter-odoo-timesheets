import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

part 'external_timesheets_dao.g.dart';

@DriftAccessor(tables: [ExternalTimesheets])
class ExternalTimesheetsDao extends DatabaseAccessor<AppDatabase>
    with _$ExternalTimesheetsDaoMixin {
  ExternalTimesheetsDao(AppDatabase db) : super(db);

  // CRUD operations for ExternalTimesheets
  Future<int> createExternalTimesheet(
          ExternalTimesheetsCompanion externalTimesheetsCompanion) =>
      into(externalTimesheets).insert(externalTimesheetsCompanion);

  Future<ExternalTimesheet?> getExternalTimesheetById(
          int externalTimesheetId) =>
      (select(externalTimesheets)
            ..where((t) => t.id.equals(externalTimesheetId)))
          .getSingleOrNull();

  Future<List<ExternalTimesheet>> getAllExternalTimesheets() =>
      select(externalTimesheets).get();

  Future<List<ExternalTimesheet>> getPaginatedExternalTimesheets(
          int limit, int? offset) =>
      (select(externalTimesheets)..limit(limit, offset: offset)).get();

  Future<void> updateExternalTimesheet(ExternalTimesheet externalTimesheet) =>
      update(externalTimesheets).replace(externalTimesheet);

  Future<int> deleteExternalTimesheet(ExternalTimesheet externalTimesheet) =>
      delete(externalTimesheets).delete(externalTimesheet);

  Future<List<ExternalTimesheet>> getExternalTimesheetsByIds(
          List<int> externalTimesheetIds) =>
      (select(externalTimesheets)
            ..where(
              (t) => t.externalId.isIn(externalTimesheetIds),
            ))
          .get();
  // TODO maybe all the list methods can be merged into one, need to attemp to do so
  Future<List<ExternalTimesheet>> getExternalTimesheetsByInternalIds(
          List<int> internalIds) =>
      (select(externalTimesheets)..where((t) => t.internalId.isIn(internalIds)))
          .get();

  Future<void> batchDeleteExternalTimesheets(List<int> ids) => batch((batch) {
        batch.deleteWhere(externalTimesheets, (t) => t.id.isIn(ids));
      });
}

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
}

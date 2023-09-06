import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/project/data/database_tables/project.dart';
import 'package:timesheets/features/task/data/database_tables/task.dart';
import 'package:timesheets/features/timesheet/data/database_tables/timesheet.dart';
import 'package:timesheets/features_refactored/app/data/dao.dart';

part 'timesheets_dao.g.dart';

@DriftAccessor(tables: [Projects, Tasks, Timesheets])
class TimesheetsDao extends DatabaseAccessor<AppDatabase>
    with _$TimesheetsDaoMixin
    implements Dao<Timesheet, TimesheetsCompanion> {
  TimesheetsDao(super.attachedDatabase);

  @override
  Future<List<Timesheet>> getAll() => select(timesheets).get();

  @override
  Future<Timesheet?> getById(int id) =>
      (select(timesheets)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  @override
  Future<List<Timesheet>> getPaginatedEntities(
      {int? offset, int? limit, String? search}) {
    final query = select(timesheets);
    if (limit != null) {
      query.limit(
        limit,
        offset: offset,
      );
    }

    if (search != null) {
      query.where((tbl) => tbl.description.contains(search));
    }

    return query.get();
  }

  @override
  Future<int> insertEntity(TimesheetsCompanion insertableEntity) =>
      into(timesheets).insert(insertableEntity);

  @override
  Future<bool> updateEntity(Timesheet entity) =>
      update(timesheets).replace(entity);

  @override
  Future<int> deleteEntity(int id) =>
      (delete(timesheets)..where((tbl) => tbl.id.equals(id))).go();
}

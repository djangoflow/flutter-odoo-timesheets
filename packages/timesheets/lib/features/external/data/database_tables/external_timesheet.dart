import 'package:drift/drift.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class ExternalTimesheets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get externalId => integer().nullable()();
  IntColumn get internalId => integer()
      .references(Timesheets, #id, onDelete: KeyAction.cascade)
      .nullable()();

  DateTimeColumn get lastSycned => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

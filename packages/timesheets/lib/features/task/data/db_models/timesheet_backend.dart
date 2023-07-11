import 'package:drift/drift.dart';
import 'package:timesheets/features/task/task.dart';

class TimesheetBackends extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get timesheetId => integer().references(Timesheets, #id)();
  IntColumn get backendId => integer().references(Backends, #id)();
  DateTimeColumn get lastSynced => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

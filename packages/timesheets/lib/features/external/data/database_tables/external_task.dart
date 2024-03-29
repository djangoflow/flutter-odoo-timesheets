import 'package:drift/drift.dart';
import 'package:timesheets/features/task/data/database_tables/task.dart';

class ExternalTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get internalId => integer()
      .references(Tasks, #id, onDelete: KeyAction.cascade)
      .nullable()();
  IntColumn get externalId => integer().nullable()();
  DateTimeColumn get lastSycned => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

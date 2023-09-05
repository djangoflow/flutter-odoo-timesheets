import 'package:drift/drift.dart';
import 'package:timesheets/features/project/data/database_tables/project.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer()
      .nullable()
      .references(Projects, #id, onDelete: KeyAction.cascade)();
  IntColumn get stageId => integer().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get priority => text().nullable()();
  DateTimeColumn get dateStart => dateTime().nullable()();
  DateTimeColumn get dateEnd => dateTime().nullable()();
  DateTimeColumn get dateDeadline => dateTime().nullable()();
  BoolColumn get active => boolean().nullable()();
  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

import 'package:drift/drift.dart';

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  BoolColumn get active => boolean().nullable()();
  IntColumn get color => integer().nullable()();
  BoolColumn get isFavorite => boolean().nullable()();
  IntColumn get taskCount => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

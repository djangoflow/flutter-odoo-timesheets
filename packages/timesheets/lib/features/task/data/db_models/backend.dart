import 'package:drift/drift.dart';

class Backends extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get backendType => integer()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

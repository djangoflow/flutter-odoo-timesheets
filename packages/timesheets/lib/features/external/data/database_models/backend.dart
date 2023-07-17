import 'package:drift/drift.dart';

class Backends extends Table {
  IntColumn get id => integer().autoIncrement()();
  // odoo and github, etc
  IntColumn get backendType => integer()();
  TextColumn get serverUrl => text().nullable()();
  TextColumn get db => text().nullable()();
  TextColumn get userId => text().nullable()();
  TextColumn get password => text().nullable()();
  // for github we may need
  TextColumn get token => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

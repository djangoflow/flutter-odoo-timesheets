import 'package:drift/drift.dart';
import 'package:timesheets/features/external/external.dart';

class Backends extends Table {
  IntColumn get id => integer().autoIncrement()();
  // odoo and github, etc
  IntColumn get backendType => intEnum<BackendTypeEnum>()();
  // fields for odoo
  TextColumn get serverUrl => text().nullable()();
  TextColumn get db => text().nullable()();
  IntColumn get userId => integer().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get password => text().nullable()();
  // for github we may need
  TextColumn get token => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

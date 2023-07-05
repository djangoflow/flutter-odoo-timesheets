import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';

/// a Tasks class that will extend a Table class to create a table in the database
/// There should Backends, and TaskBackends class for Table. Backends will hold list of available Backends
/// and TaskBackends will hold the relation between Tasks and Backends
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get duration => integer()();
  IntColumn get status => integer()();
  DateTimeColumn get lastTicked => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class TaskBackends extends Table {
  IntColumn get taskId => integer()();
  IntColumn get backendId => integer()();
  DateTimeColumn get lastSynced => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {taskId, backendId};
}

class Backends extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

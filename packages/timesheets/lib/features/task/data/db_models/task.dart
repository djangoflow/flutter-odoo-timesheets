import 'package:drift/drift.dart';

import 'project.dart';

/// a Tasks class that will extend a Table class to create a table in the database
/// There should Backends, and TaskBackends class for Table. Backends will hold list of available Backends
/// and TaskBackends will hold the relation between Tasks and Backends
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().nullable().references(Projects, #id)();
  TextColumn get onlineId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get duration => integer().withDefault(const Constant(0))();
  IntColumn get status => integer().withDefault(const Constant(0))();

  /// lastTicked is the last time the task was started freshly
  DateTimeColumn get lastTicked => dateTime().nullable()();

  /// firstTicked is the first time the task was started freshly
  DateTimeColumn get firstTicked => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

import 'package:drift/drift.dart';

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

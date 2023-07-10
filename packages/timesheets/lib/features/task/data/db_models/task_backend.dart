import 'package:drift/drift.dart';
import 'package:timesheets/features/task/task.dart';

class TaskBackends extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId => integer().references(Tasks, #id)();
  IntColumn get backendId => integer().references(Backends, #id)();
  DateTimeColumn get lastSynced => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

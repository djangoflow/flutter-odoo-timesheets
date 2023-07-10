import 'package:drift/drift.dart';
import 'package:timesheets/features/task/task.dart';

class Timesheets extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get finishTime => dateTime()();
  IntColumn get totalSpentSeconds => integer()();
  IntColumn get taskId => integer().references(Tasks, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

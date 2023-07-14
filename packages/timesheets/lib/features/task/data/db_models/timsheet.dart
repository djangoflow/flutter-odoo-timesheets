import 'package:drift/drift.dart';
import 'package:timesheets/features/task/task.dart';

class Timesheets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get onlineId => integer().nullable()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get totalSpentSeconds => integer()();
  IntColumn get taskId => integer().references(
        Tasks,
        #id,
        onDelete: KeyAction.cascade,
      )();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

import 'package:drift/drift.dart';

@DataClassName('TaskHistory')
class TaskHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get finishTime => dateTime()();
  IntColumn get totalSpentSeconds => integer()();
  IntColumn get taskId => integer()();
}

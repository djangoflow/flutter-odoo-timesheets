import 'package:drift/drift.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

class Timesheets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  IntColumn get projectId => integer()
      .nullable()
      .references(Projects, #id, onDelete: KeyAction.cascade)();

  IntColumn get taskId => integer()
      .nullable()
      .references(Tasks, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startTime => dateTime().nullable()();
  DateTimeColumn get endTime => dateTime().nullable()();
  RealColumn get unitAmount => real().nullable()();
}

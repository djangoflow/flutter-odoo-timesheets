import 'package:drift/drift.dart';
import 'package:timesheets/features/project/data/database_tables/project.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class Timesheets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();

  IntColumn get projectId => integer()
      .nullable()
      .references(Projects, #id, onDelete: KeyAction.cascade)();
  IntColumn get taskId => integer()
      .nullable()
      .references(Tasks, #id, onDelete: KeyAction.cascade)();

  /// indicates when timesheet was started
  DateTimeColumn get startTime => dateTime().nullable()();

  /// indicates when timesheet timer was last updated
  DateTimeColumn get endTime => dateTime().nullable()();
  RealColumn get unitAmount => real().nullable()();

  /// [FOR LOCALLY USE ONLY] Indicates the current status of the timesheet
  IntColumn get currentStatus => intEnum<TimesheetStatusEnum>()
      .clientDefault(() => TimesheetStatusEnum.initial.index)();

  /// [FOR LOCALLY USE ONLY] To keep track of the last time the timesheet was ticked
  /// for total spent time calculation
  DateTimeColumn get lastTicked => dateTime().nullable()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

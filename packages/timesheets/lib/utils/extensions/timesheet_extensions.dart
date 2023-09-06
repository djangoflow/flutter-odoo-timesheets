import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/data/database_tables/timesheet.dart';
import 'package:timesheets/features_refactored/timesheet/data/entities/timesheet_entity.dart';

extension TimesheetListExtension on List<Timesheet> {
  // bool get hasUnsyncedTimesheets =>
  //     any((timesheet) => timesheet.onlineId == null);
  // List<Timesheet> get unsyncedTimesheets =>
  //     where((timesheet) => timesheet.onlineId == null).toList();
}

extension TimesheetExtension on Timesheet {
  int get spentTimeInSeconds => ((unitAmount ?? 0) * 3600).toInt();

  int get elapsedTime {
    final elapsedTime = Duration(seconds: spentTimeInSeconds) +
        ([TimesheetStatusEnum.running, TimesheetStatusEnum.pausedByForce]
                    .contains(currentStatus) &&
                lastTicked != null
            ? DateTime.now().difference(lastTicked!)
            : Duration.zero);

    return elapsedTime.inSeconds;
  }

  DateTime? get calculatedEndDate =>
      startTime?.add(Duration(seconds: elapsedTime));
}

extension TimesheetToTimesheetEntityExtensions on Timesheet {
  TimesheetEntity toTimesheetEntity() => TimesheetEntity(
        id: id,
        taskId: taskId,
        projectId: projectId,
        currentStatus: currentStatus,
        endTime: endTime,
        isFavorite: isFavorite,
        lastTicked: lastTicked,
        startTime: startTime,
        unitAmount: unitAmount,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension TimesheetEntityToTimesheetExtensions on TimesheetEntity {
  Timesheet toTimesheet() {
    if (id == null) {
      throw ArgumentError.notNull('id can not be null');
    }

    if (createdAt == null) {
      throw ArgumentError.notNull('createdAt can not be null');
    }

    if (updatedAt == null) {
      throw ArgumentError.notNull('updatedAt can not be null');
    }

    return Timesheet(
      id: id!,
      description: description,
      projectId: projectId,
      taskId: taskId,
      currentStatus: currentStatus ?? TimesheetStatusEnum.initial,
      isFavorite: isFavorite ?? false,
      endTime: endTime,
      lastTicked: lastTicked,
      startTime: startTime,
      unitAmount: unitAmount,
      createdAt: createdAt!,
      updatedAt: updatedAt!,
    );
  }

  TimesheetsCompanion toTimesheetCompanion() => TimesheetsCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        projectId: projectId == null ? const Value.absent() : Value(projectId!),
        createdAt: createdAt == null ? const Value.absent() : Value(createdAt!),
        updatedAt: updatedAt == null ? const Value.absent() : Value(updatedAt!),
        currentStatus: currentStatus == null
            ? const Value.absent()
            : Value(currentStatus!),
        description:
            description == null ? const Value.absent() : Value(description!),
        endTime: endTime == null ? const Value.absent() : Value(endTime!),
        isFavorite:
            isFavorite == null ? const Value.absent() : Value(isFavorite!),
        lastTicked:
            lastTicked == null ? const Value.absent() : Value(lastTicked!),
        startTime: startTime == null ? const Value.absent() : Value(startTime!),
        taskId: taskId == null ? const Value.absent() : Value(taskId!),
        unitAmount:
            unitAmount == null ? const Value.absent() : Value(unitAmount!),
      );
}

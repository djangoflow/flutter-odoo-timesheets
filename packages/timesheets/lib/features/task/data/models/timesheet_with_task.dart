import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';

part 'timesheet_with_task.freezed.dart';

@freezed
class TimesheetWithTask with _$TimesheetWithTask {
  const factory TimesheetWithTask({
    required Timesheet timesheet,
    required TaskWithProject taskWithProject,
  }) = _TimesheetWithTask;
}

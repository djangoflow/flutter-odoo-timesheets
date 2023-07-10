import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';

part 'timesheet_with_task.freezed.dart';

@freezed
class TimesheetWithTask with _$TimesheetWithTask {
  const factory TimesheetWithTask({
    required Timesheet timesheet,
    required Task task,
  }) = _TimesheetWithTask;
}

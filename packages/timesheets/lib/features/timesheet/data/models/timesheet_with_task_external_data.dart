import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/task/task.dart';

import 'timesheet_external_data.dart';

part 'timesheet_with_task_external_data.freezed.dart';

@freezed
class TimesheetWithTaskExternalData with _$TimesheetWithTaskExternalData {
  const factory TimesheetWithTaskExternalData({
    required TimesheetExternalData timesheetExternalData,
    required TaskWithProjectExternalData taskWithProjectExternalData,
  }) = _TimesheetWithTaskExternalData;
}

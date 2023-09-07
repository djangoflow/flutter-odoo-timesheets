import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';

import 'timesheet.dart';

part 'timesheet_with_task_project.freezed.dart';
part 'timesheet_with_task_project.g.dart';

@freezed
class TimesheetWithTaskProject with _$TimesheetWithTaskProject {
  const factory TimesheetWithTaskProject({
    required Timesheet timesheet,
    TaskWithProject? taskWithProject,
  }) = _TimesheetWithTaskProject;

  factory TimesheetWithTaskProject.fromJson(Map<String, dynamic> json) =>
      _$TimesheetWithTaskProjectFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

part 'task_with_project.freezed.dart';
part 'task_with_project.g.dart';

@freezed
class TaskWithProject with _$TaskWithProject {
  const factory TaskWithProject({
    required Task task,
    Project? project,
  }) = _TaskWithProject;

  factory TaskWithProject.fromJson(Map<String, dynamic> json) =>
      _$TaskWithProjectFromJson(json);
}

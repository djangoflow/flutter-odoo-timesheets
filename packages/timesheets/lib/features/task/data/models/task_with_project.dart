import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:timesheets/features/app/data/db/app_database.dart';

part 'task_with_project.freezed.dart';

@freezed
class TaskWithProject with _$TaskWithProject {
  const factory TaskWithProject({
    required Task task,
    required Project project,
  }) = _TaskWithProject;
}

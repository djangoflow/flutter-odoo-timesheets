import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/data/models/task_with_external_data.dart';

part 'task_with_project_external_data.freezed.dart';

@freezed
class TaskWithProjectExternalData with _$TaskWithProjectExternalData {
  const factory TaskWithProjectExternalData({
    required TaskWithExternalData taskWithExternalData,
    required ProjectWithExternalData projectWithExternalData,
  }) = _TaskWithProjectExternalData;
}

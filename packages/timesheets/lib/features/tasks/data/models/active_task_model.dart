import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_task_model.g.dart';

part 'active_task_model.freezed.dart';

// ignore_for_file: invalid_annotation_target

@freezed
class ActiveTask with _$ActiveTask {
  const factory ActiveTask({
    required int id,
    required int projectId,
    required String projectName,
    required String taskName,
    DateTime? startTime,
  }) = _ActiveTask;

  factory ActiveTask.fromJson(Map<String, dynamic> json) =>
      _$ActiveTaskFromJson(json);
}
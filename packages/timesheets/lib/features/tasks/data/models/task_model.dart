import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.g.dart';

part 'task_model.freezed.dart';

// ignore_for_file: invalid_annotation_target

@freezed
class Task with _$Task {
  const factory Task({
    required int id,
    @JsonKey(name: 'project_id') required int projectId,
    required String name,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

}

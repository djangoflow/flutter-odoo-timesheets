// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    int? id,
    @JsonKey(name: 'project_id') required int projectId,
    @JsonKey(name: 'stage_id') int? stageId,
    String? name,
    String? description,
    String? priority,
    @JsonKey(name: 'date_start') DateTime? dateStart,
    @JsonKey(name: 'date_end') DateTime? dateEnd,
    @JsonKey(name: 'date_deadline') DateTime? dateDeadline,
    bool? active,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

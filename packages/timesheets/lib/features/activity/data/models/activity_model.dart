import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_model.g.dart';

part 'activity_model.freezed.dart';

// Use freezed annotation instead of JsonSerializable
// ignore_for_file: invalid_annotation_target
@freezed
class Activity with _$Activity {
  const factory Activity({
    required String name,
    @JsonKey(name: 'project_id') required int projectId,
    @JsonKey(name: 'task_id') required int taskId,
    @JsonKey(name: 'date_time') required String startTime,
    @JsonKey(name: 'date_time_end') required String endTime,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

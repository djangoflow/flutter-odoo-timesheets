import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class Activity {
  String name;

  @JsonKey(name: 'project_id')
  int projectId;

  @JsonKey(name: 'task_id')
  int taskId;

  @JsonKey(name: 'date_time')
  String startTime;

  @JsonKey(name: 'date_time_end')
  String endTime;

  Activity({
    required this.name,
    required this.projectId,
    required this.taskId,
    required this.startTime,
    required this.endTime,
  });

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
class Task {
  int id;

  String name;

  @JsonKey(name: 'project_id')
  int projectId;

  Task({
    required this.id,
    required this.projectId,
    required this.name,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

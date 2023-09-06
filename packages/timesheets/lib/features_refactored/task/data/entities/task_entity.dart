import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features_refactored/app/data/entity.dart';

part 'task_entity.g.dart';

@JsonSerializable()
class TaskEntity extends Entity {
  final int? id;
  @JsonKey(name: 'project_id')
  final int? projectId;
  @JsonKey(name: 'stage_id')
  final int? stageId;
  final String? name;
  final String? priority;
  @JsonKey(name: 'date_start')
  final DateTime? dateStart;
  @JsonKey(name: 'date_end')
  final DateTime? dateEnd;
  @JsonKey(name: 'date_deadline')
  final DateTime? dateDeadline;
  final bool? active;
  final String? description;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  TaskEntity({
    this.id,
    this.projectId,
    this.stageId,
    this.name,
    this.priority,
    this.dateStart,
    this.dateEnd,
    this.dateDeadline,
    this.active,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$TaskEntityToJson(this);

  @override
  TaskEntity fromJSON(Map<String, dynamic> json) => _$TaskEntityFromJson(json);
}

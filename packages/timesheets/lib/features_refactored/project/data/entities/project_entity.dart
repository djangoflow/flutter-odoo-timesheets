import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app/data/entity.dart';

part 'project_entity.g.dart';

@JsonSerializable()
class ProjectEntity extends Entity {
  final int? id;
  final String? name;
  final bool? active;
  final int? color;
  @JsonKey(name: 'is_favorite')
  final bool? isFavorite;
  @JsonKey(name: 'task_count')
  final int? taskCount;
  @JsonKey(name: 'task_ids')
  final List<int>? taskIds;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  ProjectEntity({
    this.taskIds,
    this.id,
    this.name,
    this.active,
    this.color,
    this.isFavorite,
    this.taskCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ProjectEntity.fromJson(Map<String, dynamic> json) =>
      _$ProjectEntityFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$ProjectEntityToJson(this);

  @override
  ProjectEntity fromJSON(Map<String, dynamic> json) =>
      _$ProjectEntityFromJson(json);
}

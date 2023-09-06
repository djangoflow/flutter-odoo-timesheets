import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.g.dart';

@CopyWith()
@JsonSerializable()
class Project {
  final int id;
  final String? name;
  final bool? active;
  final int? color;
  @JsonKey(name: 'is_favorite')
  final bool? isFavorite;
  @JsonKey(name: 'task_count')
  final int? taskCount;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  Project({
    required this.id,
    this.name,
    this.active,
    this.color,
    this.isFavorite,
    this.taskCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_project.freezed.dart';
part 'odoo_project.g.dart';

@freezed
class OdooProject with _$OdooProject {
  const factory OdooProject({
    required int id,
    required String name,
    @JsonKey(name: 'task_ids') List<int>? taskIds,
    int? color,
    @JsonKey(name: 'is_favorite') bool? isFavorite,
    @JsonKey(name: 'task_count') int? taskCount,
    bool? active,
  }) = _OdooProject;

  factory OdooProject.fromJson(Map<String, dynamic> json) =>
      _$OdooProjectFromJson(json);
}

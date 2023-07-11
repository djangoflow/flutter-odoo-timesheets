// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_task.freezed.dart';
part 'odoo_task.g.dart';

@freezed
class OdooTask with _$OdooTask {
  const factory OdooTask({
    required int id,
    @JsonKey(name: 'project_id') required int projectId,
    required String name,
  }) = _OdooTask;

  factory OdooTask.fromJson(Map<String, dynamic> json) =>
      _$OdooTaskFromJson(json);
}

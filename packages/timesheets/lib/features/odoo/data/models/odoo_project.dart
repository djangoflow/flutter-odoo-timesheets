import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_project.freezed.dart';
part 'odoo_project.g.dart';

@freezed
class OdooProject with _$OdooProject {
  const factory OdooProject({
    required int id,
    required String name,
  }) = _OdooProject;

  factory OdooProject.fromJson(Map<String, dynamic> json) =>
      _$OdooProjectFromJson(json);
}

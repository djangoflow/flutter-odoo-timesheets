import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.g.dart';
part 'project_model.freezed.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required int id,
    required String name,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}

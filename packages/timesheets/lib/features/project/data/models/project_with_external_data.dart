import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/app/app.dart';

part 'project_with_external_data.freezed.dart';

@freezed
class ProjectWithExternalData with _$ProjectWithExternalData {
  const factory ProjectWithExternalData({
    required Project project,
    ExternalProject? externalProject,
  }) = _ProjectWithExternalData;
}

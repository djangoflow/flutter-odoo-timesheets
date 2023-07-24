import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_retrieve_filter.freezed.dart';

@freezed
class ProjectRetrieveFilter with _$ProjectRetrieveFilter {
  const factory ProjectRetrieveFilter({
    required int id,
  }) = _ProjectRetrieveFilter;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_retrieve_filter.freezed.dart';
part 'project_retrieve_filter.g.dart';

@freezed
class ProjectRetrieveFilter with _$ProjectRetrieveFilter {
  const factory ProjectRetrieveFilter({
    required int id,
  }) = _ProjectRetrieveFilter;

  factory ProjectRetrieveFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$ProjectRetrieveFilterFromJson(map);
}

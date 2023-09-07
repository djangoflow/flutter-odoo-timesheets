import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:timesheets/features/app/app.dart';

part 'project_data_filter.freezed.dart';
part 'project_data_filter.g.dart';

@freezed
class ProjectDataFilter with _$ProjectDataFilter implements ByIdFilter<int> {
  const ProjectDataFilter._();

  @Implements<ByIdFilter<int>>()
  const factory ProjectDataFilter({
    required int id,
  }) = _ProjectDataFilter;

  factory ProjectDataFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$ProjectDataFilterFromJson(map);

  @override
  copyWithId(int id) => copyWith(id: id);
}

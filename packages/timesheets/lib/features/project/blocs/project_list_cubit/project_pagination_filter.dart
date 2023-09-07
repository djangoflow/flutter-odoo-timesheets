import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:list_bloc/list_bloc.dart';

part 'project_pagination_filter.freezed.dart';
part 'project_pagination_filter.g.dart';

@freezed
class ProjectPaginationFilter
    with _$ProjectPaginationFilter
    implements OffsetLimitFilter {
  const ProjectPaginationFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory ProjectPaginationFilter({
    @Default(50) int limit,
    @Default(0) int offset,
    bool? isFavorite,
  }) = _ProjectPaginationFilter;

  factory ProjectPaginationFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$ProjectPaginationFilterFromJson(map);

  @override
  ProjectPaginationFilter copyWithOffset(int offset) =>
      copyWith(offset: offset);
}

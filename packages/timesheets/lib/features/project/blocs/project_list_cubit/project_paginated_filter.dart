import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:list_bloc/list_bloc.dart';

part 'project_paginated_filter.freezed.dart';
part 'project_paginated_filter.g.dart';

@freezed
class ProjectPaginatedFilter
    with _$ProjectPaginatedFilter
    implements OffsetLimitFilter {
  const ProjectPaginatedFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory ProjectPaginatedFilter({
    @Default(25) int limit,
    @Default(0) int offset,
    bool? isFavorite,
  }) = _ProjectPaginatedFilter;

  factory ProjectPaginatedFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$ProjectPaginatedFilterFromJson(map);

  @override
  ProjectPaginatedFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:list_bloc/list_bloc.dart';

part 'task_paginated_filter.freezed.dart';
part 'task_paginated_filter.g.dart';

@freezed
class TaskPaginatedFilter
    with _$TaskPaginatedFilter
    implements OffsetLimitFilter {
  const TaskPaginatedFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory TaskPaginatedFilter({
    @Default(25) int limit,
    @Default(0) int offset,
    int? projectId,
    bool? isFavorite,
  }) = _TaskPaginatedFilter;

  factory TaskPaginatedFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TaskPaginatedFilterFromJson(map);

  @override
  TaskPaginatedFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

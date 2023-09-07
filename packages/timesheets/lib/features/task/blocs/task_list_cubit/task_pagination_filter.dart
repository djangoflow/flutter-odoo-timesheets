import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:list_bloc/list_bloc.dart';

part 'task_pagination_filter.freezed.dart';
part 'task_pagination_filter.g.dart';

@freezed
class TaskPaginationFilter
    with _$TaskPaginationFilter
    implements OffsetLimitFilter {
  const TaskPaginationFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory TaskPaginationFilter({
    @Default(50) int limit,
    @Default(0) int offset,
    int? projectId,
    bool? isFavorite,
    String? search,
  }) = _TaskPaginationFilter;

  factory TaskPaginationFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TaskPaginationFilterFromJson(map);

  @override
  TaskPaginationFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

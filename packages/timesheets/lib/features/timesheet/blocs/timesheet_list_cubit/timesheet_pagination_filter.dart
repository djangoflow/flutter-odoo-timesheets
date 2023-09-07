import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:list_bloc/list_bloc.dart';

part 'timesheet_pagination_filter.freezed.dart';
part 'timesheet_pagination_filter.g.dart';

@freezed
class TimesheetPaginationFilter
    with _$TimesheetPaginationFilter
    implements OffsetLimitFilter {
  const TimesheetPaginationFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory TimesheetPaginationFilter({
    @Default(50) int limit,
    @Default(0) int offset,
    int? projectId,
    int? taskId,
    bool? isFavorite,
    bool? isEndDateNull,
  }) = _TimesheetPaginationFilter;

  factory TimesheetPaginationFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TimesheetPaginationFilterFromJson(map);

  @override
  TimesheetPaginationFilter copyWithOffset(int offset) =>
      copyWith(offset: offset);
}

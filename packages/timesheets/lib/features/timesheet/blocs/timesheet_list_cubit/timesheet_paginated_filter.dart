import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:list_bloc/list_bloc.dart';

part 'timesheet_paginated_filter.freezed.dart';
part 'timesheet_paginated_filter.g.dart';

@freezed
class TimesheetPaginatedFilter
    with _$TimesheetPaginatedFilter
    implements OffsetLimitFilter {
  const TimesheetPaginatedFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory TimesheetPaginatedFilter({
    @Default(25) int limit,
    @Default(0) int offset,
    int? projectId,
    int? taskId,
    bool? isFavorite,
  }) = _TimesheetPaginatedFilter;

  factory TimesheetPaginatedFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TimesheetPaginatedFilterFromJson(map);

  @override
  TimesheetPaginatedFilter copyWithOffset(int offset) =>
      copyWith(offset: offset);
}

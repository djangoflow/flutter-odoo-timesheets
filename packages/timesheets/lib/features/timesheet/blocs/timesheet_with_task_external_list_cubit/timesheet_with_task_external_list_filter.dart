// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';

part 'timesheet_with_task_external_list_filter.freezed.dart';
part 'timesheet_with_task_external_list_filter.g.dart';

@freezed
class TimesheetWithTaskExternalListFilter
    with _$TimesheetWithTaskExternalListFilter
    implements OffsetLimitFilter {
  const TimesheetWithTaskExternalListFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory TimesheetWithTaskExternalListFilter({
    @Default(50) int limit,
    @Default(0) int offset,
    bool? isLocal,
    int? taskId,
    bool? isEndDateNull,
    bool? isProjectLocal,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    @Default([])
    List<OrderingFilter<$TimesheetsTable>> orderingFilters,
  }) = _TimesheetWithTaskExternalListFilter;

  factory TimesheetWithTaskExternalListFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TimesheetWithTaskExternalListFilterFromJson(map);

  @override
  TimesheetWithTaskExternalListFilter copyWithOffset(int offset) =>
      copyWith(offset: offset);
}

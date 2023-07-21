import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';

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
    @Default(false) bool isLocal,
    int? taskId,
  }) = _TimesheetWithTaskExternalListFilter;

  factory TimesheetWithTaskExternalListFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TimesheetWithTaskExternalListFilterFromJson(map);

  @override
  TimesheetWithTaskExternalListFilter copyWithOffset(int offset) =>
      copyWith(offset: offset);
}

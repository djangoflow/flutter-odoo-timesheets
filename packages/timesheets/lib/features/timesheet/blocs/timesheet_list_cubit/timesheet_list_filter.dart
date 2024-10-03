import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';

part 'timesheet_list_filter.freezed.dart';
part 'timesheet_list_filter.g.dart';

@freezed
class TimesheetListFilter
    with _$TimesheetListFilter
    implements OffsetLimitFilter {
  const TimesheetListFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory TimesheetListFilter({
    @Default(50) int limit,
    @Default(0) int offset,
    int? projectId,
    int? taskId,
    bool? activeOnly,
    bool? favoriteOnly,
  }) = _TimesheetListFilter;

  factory TimesheetListFilter.fromJson(Map<String, dynamic> json) =>
      _$TimesheetListFilterFromJson(json);

  @override
  TimesheetListFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'timesheet_list_filter.freezed.dart';
part 'timesheet_list_filter.g.dart';

@freezed
class TimesheetListFilter with _$TimesheetListFilter {
  const factory TimesheetListFilter({
    int? taskId,
  }) = _TimesheetListFilter;

  factory TimesheetListFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TimesheetListFilterFromJson(map);
}

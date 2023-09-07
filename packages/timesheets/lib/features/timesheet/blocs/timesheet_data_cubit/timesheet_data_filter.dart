import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:timesheets/features/app/app.dart';

part 'timesheet_data_filter.freezed.dart';
part 'timesheet_data_filter.g.dart';

@freezed
class TimesheetDataFilter
    with _$TimesheetDataFilter
    implements ByIdFilter<int> {
  const TimesheetDataFilter._();

  @Implements<ByIdFilter<int>>()
  const factory TimesheetDataFilter({
    required int id,
  }) = _TimesheetDataFilter;

  factory TimesheetDataFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TimesheetDataFilterFromJson(map);

  @override
  copyWithId(int id) => copyWith(id: id);
}

// lib/features/timesheet/blocs/timesheet_data_cubit/timesheet_retrieve_filter.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'timesheet_retrieve_filter.freezed.dart';
part 'timesheet_retrieve_filter.g.dart';

@freezed
class TimesheetRetrieveFilter with _$TimesheetRetrieveFilter {
  const factory TimesheetRetrieveFilter({
    required int id,
  }) = _TimesheetRetrieveFilter;

  factory TimesheetRetrieveFilter.fromJson(Map<String, dynamic> json) =>
      _$TimesheetRetrieveFilterFromJson(json);
}

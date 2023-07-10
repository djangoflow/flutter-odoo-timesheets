import 'package:freezed_annotation/freezed_annotation.dart';

part 'timesheet_retrieve_filter.freezed.dart';

@freezed
class TimesheetRetrieveFilter with _$TimesheetRetrieveFilter {
  const factory TimesheetRetrieveFilter({
    required int taskHistoryId,
  }) = _TimesheetRetrieveFilter;
}

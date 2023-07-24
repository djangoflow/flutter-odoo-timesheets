import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/app/app.dart';

part 'timesheet_external_data.freezed.dart';

@freezed
class TimesheetExternalData with _$TimesheetExternalData {
  const factory TimesheetExternalData({
    required Timesheet timesheet,
    ExternalTimesheet? externalTimesheet,
  }) = _TimesheetExternalData;
}

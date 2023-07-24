// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_timesheet_request.freezed.dart';
part 'odoo_timesheet_request.g.dart';

@Freezed()
class OdooTimesheetRequest with _$OdooTimesheetRequest {
  @JsonSerializable(includeIfNull: false)
  const factory OdooTimesheetRequest({
    String? name,
    int? id,
    @JsonKey(name: 'project_id') required int projectId,
    @JsonKey(name: 'task_id') required int taskId,
    @JsonKey(name: 'date_time') required String startTime,
    @JsonKey(name: 'date_time_end') required String endTime,
    @JsonKey(name: 'unit_amount') required double unitAmount,
  }) = _OdooTimesheetRequest;

  factory OdooTimesheetRequest.fromJson(Map<String, dynamic> json) =>
      _$OdooTimesheetRequestFromJson(json);
}

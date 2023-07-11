// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_timesheet.freezed.dart';
part 'odoo_timesheet.g.dart';

@Freezed()
class OdooTimesheet with _$OdooTimesheet {
  @JsonSerializable(includeIfNull: false)
  const factory OdooTimesheet({
    String? name,
    int? id,
    @JsonKey(name: 'project_id') required int projectId,
    @JsonKey(name: 'task_id') required int taskId,
    @JsonKey(name: 'date_time') required String startTime,
    @JsonKey(name: 'date_time_end') required String endTime,
    @JsonKey(name: 'unit_amount') required double unitAmount,
  }) = _OdooTimesheet;

  factory OdooTimesheet.fromJson(Map<String, dynamic> json) =>
      _$OdooTimesheetFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_timesheet.freezed.dart';
part 'odoo_timesheet.g.dart';

@Freezed()
class OdooTimesheet with _$OdooTimesheet {
  const factory OdooTimesheet({
    String? name,
    required int id,
    @JsonKey(name: 'project_id') required List<Object> project,
    @JsonKey(name: 'task_id') required List<Object> task,
    @JsonKey(name: 'date_time') required DateTime startTime,
    @JsonKey(name: 'date_time_end') required DateTime endTime,
    @JsonKey(name: 'unit_amount') required double unitAmount,
  }) = _OdooTimesheet;

  factory OdooTimesheet.fromJson(Map<String, dynamic> json) =>
      _$OdooTimesheetFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_timesheet_list_filter.freezed.dart';

@freezed
class OdooTimesheetListFilter with _$OdooTimesheetListFilter {
  const factory OdooTimesheetListFilter({
    required int userId,
    required int projectId,
    required int taskId,
  }) = _OdooTimesheetListFilter;
}

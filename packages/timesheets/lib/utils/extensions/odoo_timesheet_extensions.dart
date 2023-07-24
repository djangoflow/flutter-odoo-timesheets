import 'package:timesheets/features/odoo/data/models/odoo_timesheet.dart';

extension OdooTimesheetExtensions on OdooTimesheet {
  int? get taskId {
    if (task.isEmpty) {
      return null;
    }
    return task.first as int;
  }

  String? get taskName {
    if (task.length != 2) {
      return null;
    }
    return task.last as String;
  }
}

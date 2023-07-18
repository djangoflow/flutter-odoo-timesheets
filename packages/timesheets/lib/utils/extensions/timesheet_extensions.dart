import 'package:timesheets/features/app/app.dart';

extension TimesheetListExtension on List<Timesheet> {
  // bool get hasUnsyncedTimesheets =>
  //     any((timesheet) => timesheet.onlineId == null);
  // List<Timesheet> get unsyncedTimesheets =>
  //     where((timesheet) => timesheet.onlineId == null).toList();
}

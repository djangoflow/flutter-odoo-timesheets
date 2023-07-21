import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

extension TimesheetListExtension on List<Timesheet> {
  // bool get hasUnsyncedTimesheets =>
  //     any((timesheet) => timesheet.onlineId == null);
  // List<Timesheet> get unsyncedTimesheets =>
  //     where((timesheet) => timesheet.onlineId == null).toList();
}

extension TimesheetExtension on Timesheet {
  int get spentTimeInSeconds => ((unitAmount ?? 0) * 3600).toInt();

  int get elapsedTime {
    final elapsedTime = Duration(seconds: spentTimeInSeconds) +
        ([TimesheetStatusEnum.running, TimesheetStatusEnum.pausedByForce]
                    .contains(currentStatus) &&
                lastTicked != null
            ? DateTime.now().difference(lastTicked!)
            : Duration.zero);

    return elapsedTime.inSeconds;
  }
}

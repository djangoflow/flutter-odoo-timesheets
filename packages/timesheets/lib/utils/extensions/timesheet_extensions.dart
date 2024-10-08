import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

extension TimesheetExtension on TimesheetModel {
  int get spentTimeInSeconds => ((unitAmount ?? 0) * 3600).toInt();

  int get elapsedTime {
    final now = DateTime.timestamp();
    final elapsedTime = Duration(seconds: spentTimeInSeconds) +
        ([TimerStatus.running, TimerStatus.pausedByForce]
                    .contains(currentStatus) &&
                lastTicked != null
            ? now.difference(lastTicked!)
            : Duration.zero);

    return elapsedTime.inSeconds;
  }
}

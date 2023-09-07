import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

extension TimesheetExtension on Timesheet {
  int get spentTimeInSeconds => ((unitAmount ?? 0) * 3600).toInt();

  int get elapsedTime {
    final elapsedTime = Duration(seconds: spentTimeInSeconds) +
        ([TimerStatus.running, TimerStatus.pausedByForce]
                    .contains(timerStatus) &&
                lastTicked != null
            ? DateTime.now().difference(lastTicked!)
            : Duration.zero);

    return elapsedTime.inSeconds;
  }

  DateTime? get calculatedEndDate =>
      startTime?.add(Duration(seconds: elapsedTime));
}

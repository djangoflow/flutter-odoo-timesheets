import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timer/timer.dart';

extension TaskExtensions on Task {
  // int get elapsedTime {
  //   final elapsedTime = Duration(seconds: duration) +
  //       ([
  //                 TimesheetStatusEnum.running.index,
  //                 TimesheetStatusEnum.pausedByForce.index
  //               ].contains(status) &&
  //               lastTicked != null
  //           ? DateTime.now().difference(lastTicked!)
  //           : Duration.zero);
  //   return elapsedTime.inSeconds;
  // }
}

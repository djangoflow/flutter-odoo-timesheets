import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

@RoutePage()
class TimesheetDetailsPage extends StatelessWidget {
  const TimesheetDetailsPage({super.key, @pathParam required this.timesheetId});

  final int timesheetId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetExpansionPanel extends ExpansionPanel {
  TimesheetExpansionPanel({
    required this.timesheet,
    super.isExpanded,
    super.backgroundColor,
    super.canTapOnHeader,
  }) : super(
          headerBuilder: (context, isExpanded) => _TimesheetExpansionHeader(
            timesheet: timesheet,
          ),
          body: const Text('Expanded'),
        );
  final Timesheet timesheet;
}

class _TimesheetExpansionHeader extends StatelessWidget {
  const _TimesheetExpansionHeader({super.key, required this.timesheet});
  final Timesheet timesheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.all(kPadding.h * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (timesheet.startTime != null) ...[
            Text(
              timesheet.startTime!.toDayString(),
              style: textTheme.bodySmall,
            ),
            SizedBox(
              height: kPadding.h / 2,
            ),
            Text(
              timesheet.startTime!.toDateString(delimeter: '.'),
              style: textTheme.titleMedium,
            ),
            SizedBox(
              height: kPadding.h / 2,
            ),
            Text(
              'Start Time ${timesheet.startTime!.toTimeString()}',
              style: textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

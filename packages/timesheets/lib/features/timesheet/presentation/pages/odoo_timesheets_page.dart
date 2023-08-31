import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/presentation/timesheets_listview.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class OdooTimesheetsPage extends StatelessWidget {
  const OdooTimesheetsPage({super.key});

  @override
  Widget build(BuildContext context) => AppVisiblityBuilder(
        key: const ValueKey('synced_timesheets_builder'),
        appVisibilityKey: const ValueKey('synced_timesheets_page'),
        child: TimesheetListView(
          timesheetWithTaskExternalListFilter:
              const TimesheetWithTaskExternalListFilter(
            isProjectLocal: false,
            isEndDateNull: true,
          ),
          emptyBuilder: (context, state) => OdooTimesheetsPlaceHolder(
            onGetStarted: () => context.router.push(
              TimesheetRouter(
                children: [
                  TimesheetAddRoute(),
                ],
              ),
            ),
          ),
        ),
      );
}

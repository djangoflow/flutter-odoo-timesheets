import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/presentation/timesheets_listview.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class LocalTimesheetsPage extends StatelessWidget {
  const LocalTimesheetsPage({super.key});

  @override
  Widget build(BuildContext context) => AppVisiblityBuilder(
        key: const ValueKey('local_timesheets_builder'),
        appVisibilityKey: const ValueKey('local_timesheets_page'),
        child: InitialTimesheetOrderingFilterWrapper(
          builder: (initialOrderingFilter) => TimesheetListView(
            timesheetWithTaskExternalListFilter:
                TimesheetWithTaskExternalListFilter(
              isProjectLocal: true,
              isEndDateNull: true,
              orderingFilters:
                  initialOrderingFilter != null ? [initialOrderingFilter] : [],
            ),
            emptyBuilder: (context, state) => LocalTimesheetsPlaceHolder(
              onGetStarted: () => context.router.push(
                TimesheetRouter(
                  children: [
                    TimesheetAddRoute(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

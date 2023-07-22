import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_with_task_external_list_cubit/timesheet_with_task_external_list_filter.dart';
import 'package:timesheets/features/timesheet/presentation/timesheets_listview.dart';

@RoutePage()
class LocalTimesheetsPage extends StatelessWidget {
  const LocalTimesheetsPage({super.key});

  @override
  Widget build(BuildContext context) => const AppVisiblityBuilder(
        key: ValueKey('local_timesheets_builder'),
        appVisibilityKey: ValueKey('local_timesheets_page'),
        child: TimesheetListView(
          timesheetWithTaskExternalListFilter:
              TimesheetWithTaskExternalListFilter(
            isLocal: true,
            isEndDateNull: true,
          ),
        ),
      );
}

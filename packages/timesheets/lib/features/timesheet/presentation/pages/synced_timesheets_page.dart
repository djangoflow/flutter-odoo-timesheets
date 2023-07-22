import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_with_task_external_list_cubit/timesheet_with_task_external_list_filter.dart';
import 'package:timesheets/features/timesheet/presentation/timesheets_listview.dart';

@RoutePage()
class SyncedTimesheetsPage extends StatelessWidget {
  const SyncedTimesheetsPage({super.key});

  @override
  Widget build(BuildContext context) => const AppVisiblityBuilder(
        key: ValueKey('synced_timesheets_builder'),
        appVisibilityKey: ValueKey('synced_timesheets_page'),
        child: TimesheetListView(
          timesheetWithTaskExternalListFilter:
              TimesheetWithTaskExternalListFilter(
            isProjectLocal: false,
            isEndDateNull: true,
          ),
        ),
      );
}

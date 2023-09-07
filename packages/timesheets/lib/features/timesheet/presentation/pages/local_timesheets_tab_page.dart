import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage(name: 'LocalTimesheetsTab')
class LocalTimesheetsPage extends StatelessWidget implements AutoRouteWrapper {
  const LocalTimesheetsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    context.read<LocalTimesheetWithTaskProjectListCubit>().load(
          const TimesheetPaginationFilter(
            isEndDateNull: true,
          ),
        );
    return this;
  }

  @override
  Widget build(BuildContext context) => AppVisiblityBuilder(
        key: const ValueKey('local_timesheets_builder'),
        appVisibilityKey: const ValueKey('local_timesheets_page'),
        onVisibilityChanged: (isVisible) {
          final cubit = context.read<LocalTimesheetWithTaskProjectListCubit>();
          if (isVisible == true) {
            cubit.reactivate();
            // cubit.reload(
            //   cubit.state.filter?.copyWith(
            //     offset: 0,
            //   ),
            // );
          } else {
            cubit.deactivate();
          }
        },
        child: TimesheetListView<LocalTimesheetWithTaskProjectListCubit>(
          emptyBuilder: (context, state) =>
              LocalTimesheetsPlaceHolder(onGetStarted: () async {
            final cubit =
                context.read<LocalTimesheetWithTaskProjectListCubit>();
            final result = await context.router.push(
              TimesheetsRouter(
                children: [
                  TimesheetAddRoute(),
                ],
              ),
            );

            if (result != null && result is bool && result == true) {
              cubit.reload();
            }
          }),
        ),
      );
}

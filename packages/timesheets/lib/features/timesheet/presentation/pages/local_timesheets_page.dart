import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/presentation/timesheets_listview.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class LocalTimesheetsPage extends StatelessWidget implements AutoRouteWrapper {
  const LocalTimesheetsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      InitialTimesheetOrderingFilterWrapper(
        builder: (initialOrderingFilter) {
          context.read<LocalTimesheetWithTaskExternalListCubit>().load(
                TimesheetWithTaskExternalListFilter(
                  isProjectLocal: true,
                  isEndDateNull: true,
                  orderingFilters: initialOrderingFilter != null
                      ? [initialOrderingFilter]
                      : [],
                ),
              );
          return this;
        },
      );

  @override
  Widget build(BuildContext context) => AppVisiblityBuilder(
        key: const ValueKey('local_timesheets_builder'),
        appVisibilityKey: const ValueKey('local_timesheets_page'),
        onVisibilityChanged: (isVisible) {
          final cubit = context.read<LocalTimesheetWithTaskExternalListCubit>();
          if (isVisible == true) {
            cubit.reactivate();
            cubit.reload();
          } else {
            cubit.deactivate();
          }
        },
        child: InitialTimesheetOrderingFilterWrapper(
          builder: (initialOrderingFilter) =>
              TimesheetListView<LocalTimesheetWithTaskExternalListCubit>(
            emptyBuilder: (context, state) =>
                LocalTimesheetsPlaceHolder(onGetStarted: () async {
              final cubit =
                  context.read<LocalTimesheetWithTaskExternalListCubit>();
              final result = await context.router.push(
                TimesheetRouter(
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
        ),
      );
}

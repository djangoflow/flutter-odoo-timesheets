import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class TimesheetListPage extends StatelessWidget implements AutoRouteWrapper {
  const TimesheetListPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      InitialTimesheetOrderingFilterWrapper(
        builder: (initialOrderingFilter) {
          context.read<TimesheetRelationalListCubit>().load(
                const TimesheetListFilter(
                  activeOnly: true,
                  favoriteOnly: false,
                  // TODO fix this ordering
                  // orderingFilters: initialOrderingFilter != null
                  //     ? [initialOrderingFilter]
                  //     : [],
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
          final cubit = context.read<TimesheetRelationalListCubit>();
          if (isVisible == true) {
            cubit.reactivate();
            cubit.reload();
          } else {
            cubit.deactivate();
          }
        },
        child: InitialTimesheetOrderingFilterWrapper(
          builder: (initialOrderingFilter) =>
              TimesheetListView<TimesheetRelationalListCubit>(
            emptyBuilder: (context, state) =>
                TimesheetsPlaceHolder(onGetStarted: () async {
              final cubit = context.read<TimesheetRelationalListCubit>();
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

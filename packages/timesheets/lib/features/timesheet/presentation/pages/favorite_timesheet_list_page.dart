import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class FavoriteTimesheetListPage extends StatelessWidget
    implements AutoRouteWrapper {
  const FavoriteTimesheetListPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      InitialTimesheetOrderingFilterWrapper(
        builder: (initialOrderingFilter) {
          context.read<FavoriteTimesheetRelationalListCubit>().load(
                const TimesheetListFilter(
                  activeOnly: true,
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
          final cubit = context.read<FavoriteTimesheetRelationalListCubit>();
          if (isVisible == true) {
            cubit.reactivate();
            cubit.reload();
          } else {
            cubit.deactivate();
          }
        },
        child: InitialTimesheetOrderingFilterWrapper(
          builder: (initialOrderingFilter) =>
              TimesheetListView<FavoriteTimesheetRelationalListCubit>(
            emptyBuilder: (context, state) =>
                FavoriteTimesheetsPlaceHolder(onGetStarted: () async {
              final cubit =
                  context.read<FavoriteTimesheetRelationalListCubit>();
              final result = await context.router.push(
                TimesheetRouter(
                  children: [
                    TimesheetAddRoute(
                      isInitiallyFavorite: true,
                    ),
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

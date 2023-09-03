import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/presentation/timesheets_listview.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class FavoriteTimesheetsPage extends StatelessWidget
    implements AutoRouteWrapper {
  const FavoriteTimesheetsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      InitialTimesheetOrderingFilterWrapper(
        builder: (initialOrderingFilter) {
          context.read<FavoriteTimesheetWithTaskExternalListCubit>().load(
                TimesheetWithTaskExternalListFilter(
                  isEndDateNull: true,
                  isFavorite: true,
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
        key: const ValueKey('fav_timesheets_builder'),
        appVisibilityKey: const ValueKey('fav_timesheets_page'),
        onVisibilityChanged: (isVisible) {
          final cubit =
              context.read<FavoriteTimesheetWithTaskExternalListCubit>();
          if (isVisible == true) {
            cubit.reactivate();
            cubit.reload();
          } else {
            cubit.deactivate();
          }
        },
        child: InitialTimesheetOrderingFilterWrapper(
          builder: (initialOrderingFilter) =>
              TimesheetListView<FavoriteTimesheetWithTaskExternalListCubit>(
            emptyBuilder: (context, state) => FavoriteTimesheetsPlaceHolder(
              onGetStarted: () async {
                final cubit =
                    context.read<FavoriteTimesheetWithTaskExternalListCubit>();
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
              },
            ),
          ),
        ),
      );
}

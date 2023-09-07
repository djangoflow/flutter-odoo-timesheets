import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage(name: 'FavoriteTimesheetsTab')
class FavoriteTimesheetsPage extends StatelessWidget
    implements AutoRouteWrapper {
  const FavoriteTimesheetsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    context.read<FavoriteTimesheetWithTaskProjectListCubit>().load(
          const TimesheetPaginationFilter(
            isEndDateNull: true,
            isFavorite: true,
          ),
        );

    return this;
  }

  @override
  Widget build(BuildContext context) => AppVisiblityBuilder(
        key: const ValueKey('fav_timesheets_builder'),
        appVisibilityKey: const ValueKey('fav_timesheets_page'),
        onVisibilityChanged: (isVisible) {
          final cubit =
              context.read<FavoriteTimesheetWithTaskProjectListCubit>();
          if (isVisible == true) {
            cubit.reactivate();
            print('reloading');
            cubit.reload();
          } else {
            cubit.deactivate();
          }
        },
        child: TimesheetListView<FavoriteTimesheetWithTaskProjectListCubit>(
          emptyBuilder: (context, state) => FavoriteTimesheetsPlaceHolder(
            onGetStarted: () async {
              final cubit =
                  context.read<FavoriteTimesheetWithTaskProjectListCubit>();
              final result = await context.router.push(
                TimesheetsRouter(
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
      );
}

import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/presentation/timesheets_listview.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class FavoriteTimesheetsPage extends StatelessWidget {
  const FavoriteTimesheetsPage({super.key});

  @override
  Widget build(BuildContext context) => AppVisiblityBuilder(
        key: const ValueKey('fav_timesheets_builder'),
        appVisibilityKey: const ValueKey('fav_timesheets_page'),
        child: InitialTimesheetOrderingFilterWrapper(
          builder: (initialOrderingFilter) => TimesheetListView(
            timesheetWithTaskExternalListFilter:
                TimesheetWithTaskExternalListFilter(
              isEndDateNull: true,
              isFavorite: true,
              orderingFilters:
                  initialOrderingFilter != null ? [initialOrderingFilter] : [],
            ),
            emptyBuilder: (context, state) => FavoriteTimesheetsPlaceHolder(
              onGetStarted: () => context.router.push(
                TimesheetRouter(
                  children: [
                    TimesheetAddRoute(
                      isInitiallyFavorite: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

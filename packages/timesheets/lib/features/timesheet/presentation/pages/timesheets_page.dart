import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/sync/data/database/database.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class TimesheetsPage extends StatelessWidget implements AutoRouteWrapper {
  const TimesheetsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<TabbedOrderingFilterCubit<$AnalyticLinesTable>>(
            create: (context) =>
                TabbedOrderingFilterCubit<$AnalyticLinesTable>({
              0: TimesheetRecentFirstFilter(),
              1: TimesheetRecentFirstFilter(),
            }),
            lazy: false,
          ),
          BlocProvider<TimesheetRelationalListCubit>(
            create: (context) => TimesheetRelationalListCubit(
              context.read<TimesheetRelationalRepository>(),
            ),
          ),
          BlocProvider<FavoriteTimesheetRelationalListCubit>(
            create: (context) => FavoriteTimesheetRelationalListCubit(
              context.read<TimesheetRelationalRepository>(),
            ),
          ),
        ],
        child: this,
      );

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
        routes: const [
          FavoriteTimesheetListRoute(),
          TimesheetListRoute(),
        ],
        builder: (context, child, tabController) => IconButtonTheme(
          data: AppTheme.getFilledIconButtonTheme(Theme.of(context)),
          child: GradientScaffold(
            appBar: AppBar(
              title: const Text('Timesheets'),
              scrolledUnderElevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              actions: [
                // TODO add back later
                // IconButton(
                //   onPressed: () {
                //     AppModalSheet.show(
                //       context: context,
                //       child: FilterSelector<$AnalyticLinesTable>(
                //         onFilterChanged: (f) {
                //           context
                //               .read<
                //                   TabbedOrderingFilterCubit<
                //                       $AnalyticLinesTable>>()
                //               .updateFilter(tabController.index, f);
                //         },
                //         initialFilter: context
                //                 .read<
                //                     TabbedOrderingFilterCubit<
                //                         $AnalyticLinesTable>>()
                //                 .getFilterForTab(
                //                   tabController.index,
                //                 ) ??
                //             TimesheetRecentFirstFilter(),
                //         availableFilters: [
                //           TimesheetRecentFirstFilter(),
                //           TimesheetOldestFirstFilter(),
                //         ],
                //       ),
                //     );
                //   },
                //   icon: const Icon(CupertinoIcons.arrow_up_down),
                // ),
                IconButton(
                  onPressed: () async {
                    final router = context.router;
                    TimesheetRelationalListCubit? cubit;
                    PageRouteInfo? route;
                    switch (tabController.index) {
                      case 0:
                        route = TimesheetAddRoute(
                          isInitiallyFavorite: true,
                        );
                        cubit = context
                            .read<FavoriteTimesheetRelationalListCubit>();
                        break;
                      case 1:
                        route = TimesheetAddRoute();
                        cubit = context.read<TimesheetRelationalListCubit>();
                        break;
                      default:
                        break;
                    }
                    if (route != null) {
                      final result =
                          await router.push(TimesheetRouter(children: [route]));
                      if (result != null && result is bool && result == true) {
                        cubit?.reload();
                      }
                    }
                  },
                  icon: const Icon(CupertinoIcons.add),
                ),
                const SizedBox(
                  width: kPadding * 2,
                ),
              ],
              centerTitle: false,
              bottom: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Favorites'),
                  Tab(text: 'All'),
                ],
              ),
            ),
            body: child,
          ),
        ),
      );
}

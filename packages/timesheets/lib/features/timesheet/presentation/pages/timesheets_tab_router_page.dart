import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage(
  name: 'TimesheetsTabRouter',
)
class TimesheetsTabRouterPage extends StatelessWidget
    implements AutoRouteWrapper {
  const TimesheetsTabRouterPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final timesheetWithTaskProjectRepository =
        InMemoryTimesheetWithTaskProjectRepository(
      backend: context.read<InMemoryBackend>(),
    );
    return MultiBlocProvider(providers: [
      BlocProvider<FavoriteTimesheetWithTaskProjectListCubit>(
        create: (context) => FavoriteTimesheetWithTaskProjectListCubit(
            repository: timesheetWithTaskProjectRepository),
      ),
      BlocProvider<LocalTimesheetWithTaskProjectListCubit>(
        create: (context) => LocalTimesheetWithTaskProjectListCubit(
            repository: timesheetWithTaskProjectRepository),
      ),
    ], child: this);
  }

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
        physics: const NeverScrollableScrollPhysics(),
        routes: const [
          FavoriteTimesheetsTab(),
          LocalTimesheetsTab(),
        ],
        builder: (context, child, tabController) => IconButtonTheme(
          data: AppTheme.getFilledIconButtonTheme(Theme.of(context)),
          child: GradientScaffold(
            appBar: AppBar(
              title: const Text('Timesheets'),
              scrolledUnderElevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              actions: [
                IconButton(
                  onPressed: () {
                    // AppModalSheet.show(
                    //   context: context,
                    //   child: FilterSelector<$TimesheetsTable>(
                    //     onFilterChanged: (f) {
                    //       context
                    //           .read<
                    //               TabbedOrderingFilterCubit<$TimesheetsTable>>()
                    //           .updateFilter(tabController.index, f);
                    //     },
                    //     initialFilter: context
                    //             .read<
                    //                 TabbedOrderingFilterCubit<
                    //                     $TimesheetsTable>>()
                    //             .getFilterForTab(
                    //               tabController.index,
                    //             ) ??
                    //         TimesheetRecentFirstFilter(),
                    //     availableFilters: [
                    //       TimesheetRecentFirstFilter(),
                    //       TimesheetOldestFirstFilter(),
                    //     ],
                    //   ),
                    // );
                  },
                  icon: const Icon(CupertinoIcons.arrow_up_down),
                ),
                IconButton(
                  onPressed: () async {
                    final router = context.router;
                    TimesheetWithTaskProjectListCubit? cubit;
                    PageRouteInfo? route;
                    switch (tabController.index) {
                      case 0:
                        route = TimesheetAddRoute(
                          isInitiallyFavorite: true,
                        );
                        cubit = context
                            .read<FavoriteTimesheetWithTaskProjectListCubit>();
                        break;
                      case 1:
                        route = TimesheetAddRoute();
                        cubit = context
                            .read<LocalTimesheetWithTaskProjectListCubit>();
                        break;
                      default:
                        break;
                    }
                    if (route != null) {
                      final result = await router
                          .push(TimesheetsRouter(children: [route]));
                      if (result != null && result is bool && result == true) {
                        cubit?.reload();
                      }
                    }
                  },
                  icon: const Icon(CupertinoIcons.add),
                ),
                SizedBox(
                  width: kPadding.w * 2,
                ),
              ],
              centerTitle: false,
              bottom: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Favorites'),
                  Tab(text: 'Local'),
                ],
              ),
            ),
            body: child,
          ),
        ),
      );
}

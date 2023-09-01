import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class TimesheetsPage extends StatelessWidget implements AutoRouteWrapper {
  const TimesheetsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final timesheetRepository = context.read<TimesheetRepository>();
    return MultiBlocProvider(providers: [
      BlocProvider<TabbedOrderingFilterCubit<$TimesheetsTable>>(
        create: (context) => TabbedOrderingFilterCubit<$TimesheetsTable>({
          0: TimesheetRecentFirstFilter(),
          1: TimesheetRecentFirstFilter(),
          2: TimesheetRecentFirstFilter(),
        }),
        lazy: false,
      ),
      BlocProvider<FavoriteTimesheetWithTaskExternalListCubit>(
        create: (context) =>
            FavoriteTimesheetWithTaskExternalListCubit(timesheetRepository),
      ),
      BlocProvider<OdooTimesheetWithTaskExternalListCubit>(
        create: (context) =>
            OdooTimesheetWithTaskExternalListCubit(timesheetRepository),
      ),
      BlocProvider<LocalTimesheetWithTaskExternalListCubit>(
        create: (context) =>
            LocalTimesheetWithTaskExternalListCubit(timesheetRepository),
      ),
    ], child: this);
  }

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
        routes: const [
          FavoriteTimesheetsRoute(),
          OdooTimesheetsRoute(),
          LocalTimesheetsRoute(),
        ],
        builder: (context, child, tabController) => GradientScaffold(
          appBar: AppBar(
            title: const Text('Timesheets'),
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            actions: [
              IconButton(
                onPressed: () {
                  AppModalSheet.show(
                    context: context,
                    child: FilterSelector<$TimesheetsTable>(
                      onFilterChanged: (f) {
                        context
                            .read<TabbedOrderingFilterCubit<$TimesheetsTable>>()
                            .updateFilter(tabController.index, f);
                      },
                      initialFilter: context
                              .read<
                                  TabbedOrderingFilterCubit<$TimesheetsTable>>()
                              .getFilterForTab(
                                tabController.index,
                              ) ??
                          TimesheetRecentFirstFilter(),
                      availableFilters: [
                        TimesheetRecentFirstFilter(),
                        TimesheetOldestFirstFilter(),
                      ],
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.arrow_up_down),
              ),
              IconButton(
                onPressed: () async {
                  final router = context.router;
                  TimesheetWithTaskExternalListCubit? cubit;
                  PageRouteInfo? route;
                  switch (tabController.index) {
                    case 0:
                      route = TimesheetAddRoute(
                        isInitiallyFavorite: true,
                      );
                      cubit = context
                          .read<FavoriteTimesheetWithTaskExternalListCubit>();
                      break;
                    case 1:
                      route = TimesheetAddRoute(
                        disableLocalProjectTaskSelection: true,
                      );
                      cubit = context
                          .read<OdooTimesheetWithTaskExternalListCubit>();
                      break;
                    case 2:
                      route = TimesheetAddRoute();
                      cubit = context
                          .read<LocalTimesheetWithTaskExternalListCubit>();
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
                Tab(text: 'Odoo'),
                Tab(text: 'Local'),
              ],
            ),
          ),
          body: child,
        ),
      );
}

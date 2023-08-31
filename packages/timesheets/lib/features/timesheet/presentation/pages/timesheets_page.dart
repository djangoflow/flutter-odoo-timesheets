import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/data/timesheet_ordering_filters.dart';

@RoutePage()
class TimesheetsPage extends StatelessWidget implements AutoRouteWrapper {
  const TimesheetsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider<TabbedOrderingFilterCubit<$TimesheetsTable>>(
        create: (context) => TabbedOrderingFilterCubit<$TimesheetsTable>({
          0: TimesheetRecentFirstFilter(),
          1: TimesheetRecentFirstFilter(),
          2: TimesheetRecentFirstFilter(),
        }),
        lazy: false,
        child: this,
      );

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
                onPressed: () {
                  context.router.push(
                    TimesheetRouter(
                      children: [
                        TimesheetAddRoute(),
                      ],
                    ),
                  );
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

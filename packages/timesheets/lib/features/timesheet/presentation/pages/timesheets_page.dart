import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

@RoutePage()
class TimesheetsPage extends StatelessWidget {
  const TimesheetsPage({super.key});

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
                    child: FilterSelector(onFilterChanged: (f) {
                      print(f.label);
                    }),
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
          ),
          body: Column(
            children: [
              TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Favorites'),
                  Tab(text: 'Odoo'),
                  Tab(text: 'Local'),
                ],
              ),
              Flexible(
                child: child,
              ),
            ],
          ),
        ),
      );
}

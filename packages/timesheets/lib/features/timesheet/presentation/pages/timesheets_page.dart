import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

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
        builder: (context, child, tabController) => Column(
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
      );
}

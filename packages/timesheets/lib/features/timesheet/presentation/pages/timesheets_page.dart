import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

@RoutePage()
class TimesheetsPage extends StatelessWidget {
  const TimesheetsPage({super.key});

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
        routes: const [
          SyncedTimesheetsRoute(),
          LocalTimesheetsRoute(),
        ],
        builder: (context, child, tabController) => Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: 'Synced'),
                  Tab(text: 'Local'),
                ],
              ),
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      );
}

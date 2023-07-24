import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

@RoutePage()
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
        routes: const [
          SyncedProjectsRoute(),
          LocalProjectsRoute(),
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

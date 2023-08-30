import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

@RoutePage(
  name: 'ProjectsTabRouter',
)
class ProjectsTabRouterPage extends StatelessWidget {
  const ProjectsTabRouterPage({super.key});

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
        routes: const [
          FavoriteProjectsTab(),
          OdooProjectsTab(),
          LocalProjectsTab(),
        ],
        builder: (context, child, tabController) => Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: 'Favorites'),
                  Tab(text: 'Odoo'),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

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
        builder: (context, child, tabController) => GradientScaffold(
          appBar: AppBar(
            title: const Text('Projects'),
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            actions: [
              IconButton(
                onPressed: () {
                  if (tabController.index == 0) {
                    context.router.push(
                      ProjectAddRoute(
                        isInitiallyFavorite: true,
                      ),
                    );
                  } else if (tabController.index == 1) {
                    context.router.push(
                      ProjectAddRoute(),
                    );
                  }

                  // TODO auto reload after adding project
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
        ),
      );
}

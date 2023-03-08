import 'package:timesheets/configurations/router/router.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => AutoTabsRouter(
        routes: const [
          ActivityRouterRoute(),
          SettingsRouterRoute(),
        ],
        builder: (context, child, animation) {
          final tabsRouter = AutoTabsRouter.of(context);
          // https://github.com/Milad-Akarie/auto_route_library/issues/981#issuecomment-1052004915
          final showBottomNav =
              context.topRouteMatch.meta['showBottomNav'] == true;

          return Column(
            children: [
              Expanded(child: child),
              if (showBottomNav)
                BottomNavigationBar(
                  currentIndex: tabsRouter.activeIndex,
                  onTap: (value) => tabsRouter.setActiveIndex(value),
                  items: items,
                ),
            ],
          );
        },
      );

  List<BottomNavigationBarItem> get items => const [
        BottomNavigationBarItem(
          icon: Icon(Icons.more_time),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'settings',
        ),
      ];
}

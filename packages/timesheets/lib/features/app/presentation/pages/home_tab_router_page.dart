import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

@RoutePage(name: 'HomeTabRouter')
class HomeTabRouterPage extends StatelessWidget {
  const HomeTabRouterPage({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surfaceVariant,
              Theme.of(context).colorScheme.surface,
            ],
            stops: const [.15, .85],
          ),
        ),
        child: AutoTabsRouter(
          builder: (context, child) {
            final tabsRouter = context.tabsRouter;
            return Column(
              children: [
                Expanded(
                  child: child,
                ),
                BottomNavigationBar(
                  currentIndex: tabsRouter.activeIndex,
                  onTap: tabsRouter.setActiveIndex,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.clock),
                      activeIcon: Icon(CupertinoIcons.clock_fill),
                      label: 'Timers',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.briefcase),
                      activeIcon: Icon(CupertinoIcons.briefcase_fill),
                      label: 'Projects',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.settings),
                      activeIcon: Icon(CupertinoIcons.settings_solid),
                      label: 'Settings',
                    ),
                  ],
                ),
              ],
            );
          },
          routes: const [
            // TimesheetsRoute(),
            // ProjectsTabRouter(),
            // SettingsRoute(),
          ],
        ),
      );
}

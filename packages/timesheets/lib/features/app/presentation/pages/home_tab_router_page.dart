import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

@RoutePage(name: 'HomeTabRouter')
class HomeTabRouterPage extends StatelessWidget {
  const HomeTabRouterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      appBarBuilder: (context, tabsRouter) => AppBar(
        title: Text(
          tabsRouter.current.path.capitalize,
        ),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      routes: [
        TasksRoute(),
        ProjectsRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: [
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
        );
      },
    );
  }
}

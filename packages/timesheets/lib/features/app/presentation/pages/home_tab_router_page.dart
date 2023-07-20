import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';

@RoutePage(name: 'HomeTabRouter')
class HomeTabRouterPage extends StatelessWidget {
  const HomeTabRouterPage({super.key});

  @override
  Widget build(BuildContext context) => AutoTabsScaffold(
        appBarBuilder: (context, tabsRouter) => AppBar(
          title: Text(
            tabsRouter.current.path.capitalize,
          ),
          actions: [
            if (tabsRouter.activeIndex == 0)
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.add),
                iconSize: kPadding.h * 4,
              )
          ],
          centerTitle: false,
        ),
        routes: const [
          TasksRoute(),
          ProjectsRoute(),
          SettingsRoute(),
        ],
        bottomNavigationBuilder: (context, tabsRouter) => BottomNavigationBar(
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
      );
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

@RoutePage(name: 'HomeTabRouter')
class HomeTabRouterPage extends StatelessWidget {
  const HomeTabRouterPage({super.key});

  @override
  Widget build(BuildContext context) => AutoTabsRouter(
        builder: (context, child) {
          final tabsRouter = context.tabsRouter;
          return IconButtonTheme(
            data: AppTheme.getFilledIconButtonTheme(Theme.of(context)),
            child: GradientScaffold(
              appBar: AppBar(
                title: Text(
                  tabsRouter.current.path.capitalize,
                ),
                scrolledUnderElevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                actions: [
                  if (tabsRouter.activeIndex == 0) ...[
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
                ],
                centerTitle: false,
              ),
              body: child,
              bottomNavigationBar: BottomNavigationBar(
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
            ),
          );
        },
        routes: const [
          TimesheetsRoute(),
          ProjectsTabRouter(),
          SettingsRoute(),
        ],
      );
}

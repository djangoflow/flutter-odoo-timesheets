import 'package:timesheets/configurations/configurations.dart';

export 'package:auto_route/auto_route.dart';
export 'route_parser.dart';

export 'router.gr.dart';

@AutoRouterConfig(
  deferredLoading: true,
)
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType =>
      const RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(
          path: '/splash',
          page: SplashRoute.page,
        ),
        AutoRoute(
          page: HomeTabRouter.page,
          path: '/',
          children: [
            AutoRoute(
              page: TimesheetsTabRouter.page,
              path: 'timesheets',
              initial: true,
              children: [
                AutoRoute(
                  initial: true,
                  path: 'favorite',
                  page: FavoriteTimesheetsTab.page,
                ),
                AutoRoute(
                  path: 'local',
                  page: LocalTimesheetsTab.page,
                ),
              ],
            ),
            AutoRoute(
              page: ProjectsTabRouter.page,
              path: 'projects',
              children: [
                AutoRoute(
                  page: FavoriteProjectsTab.page,
                  path: 'favorite',
                  initial: true,
                ),
                AutoRoute(
                  page: LocalProjectsTab.page,
                  path: 'local',
                ),
              ],
            ),
          ],
        ),
        AutoRoute(page: ProjectAddRoute.page, path: '/projects/add'),
        AutoRoute(
          page: TimesheetsRouter.page,
          path: '/timesheets',
          children: [
            AutoRoute(page: TimesheetAddRoute.page, path: 'add'),
          ],
        ),
        AutoRoute(
          page: TasksRouter.page,
          path: '/tasks',
          children: [
            AutoRoute(
              path: ':id',
              page: TaskDetailsRouter.page,
              children: [
                AutoRoute(
                  path: '',
                  page: TaskDetailsTabRouter.page,
                  children: [
                    AutoRoute(
                      initial: true,
                      page: TaskDetailsTimesheetsTab.page,
                      path: 'timesheets',
                    ),
                    AutoRoute(
                      page: TaskDetailsDetailsTab.page,
                      path: 'details',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        AutoRoute(path: '*', page: UnknownRouteRoute.page),
      ];
}

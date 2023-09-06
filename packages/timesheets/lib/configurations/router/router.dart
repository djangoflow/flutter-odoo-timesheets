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
              initial: true,
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
        AutoRoute(path: '*', page: UnknownRouteRoute.page),
      ];
}

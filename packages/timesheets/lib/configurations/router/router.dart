import 'package:timesheets/configurations/configurations.dart';

import 'auth_guard.dart';

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
          page: OdooLoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: HomeTabRouter.page,
          path: '/',
          children: [
            AutoRoute(
              page: TasksRouter.page,
              path: 'timers',
              initial: true,
              children: [
                AutoRoute(
                  path: '',
                  page: TasksRoute.page,
                ),
                AutoRoute(
                  path: 'add',
                  page: TaskAddRoute.page,
                ),
                AutoRoute(
                  path: 'add-odoo',
                  page: OdooTaskAddRoute.page,
                  // guards: [AuthGuard()],
                ),
                AutoRoute(
                  path: ':id',
                  page: TaskDetailsRouter.page,
                  children: [
                    AutoRoute(
                      path: '',
                      page: TaskDetailsRoute.page,
                    ),
                    AutoRoute(
                      path: 'edit',
                      page: TaskEditRoute.page,
                    ),
                    AutoRoute(
                      path: 'timesheets/:timesheetId',
                      page: TimesheetsRouter.page,
                      children: [
                        AutoRoute(
                          path: '',
                          page: TimesheetDetailsRoute.page,
                        ),
                        AutoRoute(
                          path: 'edit',
                          page: TimesheetEditRoute.page,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            AutoRoute(
              page: ProjectsRoute.page,
              path: 'projects',
              children: [
                AutoRoute(
                  page: SyncedProjectsRoute.page,
                  path: 'synced',
                ),
                AutoRoute(
                  page: LocalProjectsRoute.page,
                  path: 'local',
                ),
              ],
            ),
            AutoRoute(page: SettingsRoute.page, path: 'settings'),
          ],
        ),

        // Or redirect to home
        AutoRoute(path: '*', page: UnknownRouteRoute.page),
      ];
}
// TODO can be used with CustomRoute
// Route<T> modalSheetBuilder<T>(
//         BuildContext context, Widget child, CustomPage<T> page) =>
//     ModalBottomSheetRoute(
//       settings: page,
//       isScrollControlled: true,
//       constraints: BoxConstraints(
//         maxHeight: (MediaQuery.of(context).size.height / 10) * 7,
//       ),
//       builder: (context) => child,
//     );
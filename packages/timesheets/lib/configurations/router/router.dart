import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/authentication/authentication.dart';

import 'odoo_auth_guard.dart';

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

  AuthCubit? _authCubit;
  set authCubit(AuthCubit authCubit) => _authCubit = authCubit;

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
              page: TimesheetsRoute.page,
              path: 'timesheets',
              initial: true,
              children: [
                AutoRoute(
                  initial: true,
                  path: 'favorite',
                  page: FavoriteTimesheetsRoute.page,
                ),
                AutoRoute(
                  path: 'odoo',
                  page: OdooTimesheetsRoute.page,
                ),
                AutoRoute(
                  path: 'local',
                  page: LocalTimesheetsRoute.page,
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
                  page: OdooProjectsTab.page,
                  path: 'odoo',
                ),
                AutoRoute(
                  page: LocalProjectsTab.page,
                  path: 'local',
                ),
              ],
            ),
            AutoRoute(page: SettingsRoute.page, path: 'settings'),
          ],
        ),
        AutoRoute(page: ProjectDetailsRoute.page, path: '/projects/:projectId'),
        AutoRoute(
          page: TimesheetRouter.page,
          path: '/timesheets',
          children: [
            AutoRoute(page: TimesheetAddRoute.page, path: 'add'),
            AutoRoute(page: TimesheetMergeRoute.page, path: 'merge', guards: [
              if (_authCubit != null) OdooAuthGuard(_authCubit!),
            ]),
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
                // AutoRoute(
                //   path: 'edit',
                //   page: TaskEditRoute.page,
                // ),
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
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
        RedirectRoute(path: '/', redirectTo: '/tasks'),
        AutoRoute(
          page: TasksRouter.page,
          path: '/tasks',
          children: [
            AutoRoute(
              path: '',
              page: TasksRoute.page,
            ),
            AutoRoute(
              path: 'add',
              page: TaskAddRoute.page,
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
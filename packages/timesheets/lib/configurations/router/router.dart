import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/books/books.dart';
import 'package:timesheets/features/profile/profile.dart';

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
        RedirectRoute(path: '/', redirectTo: '/home'),
        AutoRoute(
          page: HomeRoute.page,
          path: '/home',
          children: [
            AutoRoute(
              path: 'books',
              page: BooksRouterRoute.page,
              children: bookRoutes,
            ),
            AutoRoute(
              path: 'profile',
              page: ProfileRouterRoute.page,
              children: profileRoutes,
            ),
          ],
        ),
        AutoRoute(
          path: '/splash',
          page: SplashRoute.page,
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
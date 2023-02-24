import 'package:timesheets/configurations/router/auth_guard.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/profile/profile.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

export 'package:auto_route/auto_route.dart';
export 'auth_guard.dart';
export 'route_parser.dart';

export 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  deferredLoading: true,
  routes: <AutoRoute>[
    RedirectRoute(path: '/', redirectTo: '/home'),
    AutoRoute(
      page: HomePage,
      path: '/home',
      guards: [AuthGuard],
      children: [
        AutoRoute(
          path: 'activity',
          page: ActivityRouterPage,
          children: activityRoutes,
        ),
        AutoRoute(
          path: 'profile',
          page: ProfileRouterPage,
          children: profileRoutes,
        ),
      ],
    ),
    AutoRoute(
      path: '/splash',
      page: SplashPage,
    ),
    AutoRoute(
      path: '/login',
      page: LoginPage,
      name: 'LoginRouter',
      children: loginRoutes,
    ),
    // Or redirect to home
    AutoRoute(path: '*', page: UnknownRoutePage),
  ],
)
// extend the generated private router
class $AppRouter {}

Route<T> modalSheetBuilder<T>(
        BuildContext context, Widget child, CustomPage<T> page) =>
    ModalSheetRoute(
      settings: page,
      containerBuilder: (context, animation, child) => SizedBox(
          height: (MediaQuery.of(context).size.height / 10) * 7, child: child),
      builder: (context) => child,
      expanded: false,
    );

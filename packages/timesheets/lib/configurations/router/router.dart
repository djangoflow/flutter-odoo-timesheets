import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timesheets/features/settings/presentation/pages/settings_router_page.dart';
import 'package:timesheets/features/tasks/presentation/pages/task_router_page.dart';
import 'package:timesheets/features/settings/presentation/pages/settings_routes.dart';

import '../../features/tasks/presentation/pages/task_routes.dart';

export 'package:auto_route/auto_route.dart';
export 'auth_guard.dart';
export 'route_parser.dart';

export 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  deferredLoading: true,
  routes: <AutoRoute>[
    RedirectRoute(path: '/', redirectTo: '/tasks'),
    AutoRoute(
      path: '/tasks',
      page: TasksRouterPage,
      children: taskRoutes,
    ),
    AutoRoute(
      path: '/settings',
      page: SettingsRouterPage,
      name: 'SettingsRouter',
      children: settingsRoutes,
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

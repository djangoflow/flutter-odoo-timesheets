import 'package:timesheets/configurations/router/router.dart';

final profileRoutes = [
  AutoRoute(
    path: '',
    page: ProfileRoute.page,
    initial: true,
    meta: const {
      'showBottomNav': true,
    },
  ),
  AutoRoute(
    page: ProfileEditRoute.page,
    path: 'edit',
  ),
];
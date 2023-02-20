import 'package:timesheets/configurations/router/router.dart';
import 'package:timesheets/features/profile/profile.dart';

const profileRoutes = [
  AutoRoute(
    path: '',
    page: ProfilePage,
    initial: true,
    meta: {
      'showBottomNav': true,
    },
  ),
];

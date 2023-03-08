import 'package:timesheets/configurations/router/router.dart';
import 'package:timesheets/features/settings/settings.dart';

const settingsRoutes = [
  AutoRoute(
    path: '',
    page: settingsPage,
    initial: true,
    meta: {
      'showBottomNav': true,
    },
  ),
];

import 'package:timesheets/configurations/router/router.dart';

import 'activity_details_page.dart';
import 'activity_page.dart';

const activityRoutes = [
  AutoRoute(
    path: '',
    page: ActivityPage,
    initial: true,
  ),
  AutoRoute(
    page: ActivityDetailsPage,
    path: ':activityId',
  ),
];

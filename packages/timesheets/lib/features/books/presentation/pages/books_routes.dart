import 'package:timesheets/configurations/router/router.dart';


final bookRoutes = [
  AutoRoute(
    path: '',
    page: BookListRoute.page,
    initial: true,
    meta: const {
      'showBottomNav': true,
    },
  ),
  AutoRoute(
    page: BookDetailsRoute.page,
    path: ':bookId',
  ),
];
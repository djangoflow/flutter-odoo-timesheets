import 'package:timesheets/configurations/router/router.dart';

import 'book_details_page.dart';
import 'book_list_page.dart';

const bookRoutes = [
  AutoRoute(
    path: '',
    page: BookListPage,
    initial: true,
    meta: {
      'showBottomNav': true,
    },
  ),
  AutoRoute(
    page: BookDetailsPage,
    path: ':bookId',
  ),
];
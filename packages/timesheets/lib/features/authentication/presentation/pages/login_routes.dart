import 'package:auto_route/auto_route.dart';
import 'package:timesheets/features/authentication/authentication.dart';

export 'login_router_page.dart';
export 'login_sheet.dart';

const loginRoutes = [
  AutoRoute(
    path: '',
    page: LoginOptionsPage,
    initial: true,
  ),
  AutoRoute(
    path: 'email',
    page: EmailPasswordLoginPage,
  ),
];

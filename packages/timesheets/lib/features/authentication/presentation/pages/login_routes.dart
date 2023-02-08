import 'package:auto_route/auto_route.dart';

import 'email_otp/email_otp_login_wrapper_page.dart';
import 'email_otp/email_otp_login_page.dart';
import 'email_otp/email_otp_request_page.dart';
import 'login_options_page.dart';
import 'login_redirect_page.dart';

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
      page: EmailOTPLoginWrapperPage,
      name: 'EmailLoginWrapper',
      children: [
        RedirectRoute(path: '', redirectTo: 'request'),
        AutoRoute(
          initial: true,
          path: 'request',
          page: EmailOTPRequestPage,
        ),
        AutoRoute(
          path: 'login', // maybe 'submit' instead of login?
          page: EmailOTPLoginPage,
        ),
      ]),
  AutoRoute(
    path: ':token',
    page: LoginRedirectPage,
  ),
];

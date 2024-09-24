import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:flutter/foundation.dart';

import 'router.dart';

class AuthGuard extends AutoRouteGuard {
  final DjangoflowOdooAuthCubit authCubit;

  AuthGuard({required this.authCubit});
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    debugPrint(resolver.routeName);
    final unGuardedRouteNames =
        ([LogInRouter.name, SplashRoute.name, LoginRoute.name]);

    if (authCubit.state.session == null) {
      if (unGuardedRouteNames.contains(resolver.routeName)) {
        resolver.next();
      } else {
        await resolver.redirect(
          LogInRouter(
            onLoginSuccess: (p0) {
              resolver.resolveNext(
                true,
                reevaluateNext: false,
              );
            },
            children: const [
              LoginRoute(),
            ],
          ),
          onFailure: (failure) => resolver.next(false),
        );

        if (!resolver.isResolved) {
          resolver.next(false);
        }
      }
    } else {
      if (unGuardedRouteNames.contains(resolver.routeName)) {
        if (resolver.routeName == SplashRoute.name) {
          resolver.next();
        } else {
          resolver.next(false);
          router.push(const HomeTabRouter());
        }
      } else {
        resolver.next();
      }
    }
  }
}

import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:flutter/foundation.dart';

import 'router.dart';

class OdooAuthGuard extends AutoRouteGuard {
  final DjangoflowOdooAuthCubit authCubit;

  OdooAuthGuard({required this.authCubit});
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    debugPrint(resolver.routeName);
    final unGuardedRouteNames = ([OdooLoginRoute.name, SplashRoute.name]);

    if (authCubit.state.session == null) {
      if (unGuardedRouteNames.contains(resolver.routeName)) {
        resolver.next();
      } else {
        await resolver.redirect(
          OdooLoginRoute(
            onLoginSuccess: (p0) {
              resolver.resolveNext(
                true,
                reevaluateNext: false,
              );
            },
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

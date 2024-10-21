import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:djangoflow_app_links/djangoflow_app_links.dart';
import 'package:djangoflow_error_reporter/djangoflow_error_reporter.dart';
import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'configurations/router/route_observer.dart';

class TimesheetsAppBuilder extends AppBuilder {
  TimesheetsAppBuilder({
    super.key,
    super.onDispose,
    required AppRouter appRouter,
    final String? initialDeepLink,
    super.providers,
    required super.blocProviders,
  }) : super(
          onInitState: (context) {
            VisibilityDetectorController.instance.updateInterval =
                animationDurationShort;
          },
          builder: (context) => LoginListenerWrapper(
            onLogin: (_, session) {
              _updateErrorReporterUserInformation(
                id: session?.userId.toString(),
                name: session?.userName,
                email: session?.userLogin,
              );
            },
            onLogout: (_) {
              _updateErrorReporterUserInformation();
            },
            child: AppCubitBuilder(
              builder: (context, appState) => AppGlobalLoaderOverlay(
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  scaffoldMessengerKey:
                      DjangoflowAppSnackbar.scaffoldMessengerKey,
                  title: appTitle,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: appState.themeMode,
                  locale: Locale(appState.locale, ''),
                  supportedLocales: const [
                    Locale('en', ''),
                  ],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  routerConfig: appRouter.config(
                    reevaluateListenable: ReevaluateListenable.stream(
                      context.read<DjangoflowOdooAuthCubit>().stream,
                    ),
                    includePrefixMatches: true,
                    deepLinkBuilder: (deepLink) {
                      if (kIsWeb) {
                        return deepLink;
                      } else {
                        if (initialDeepLink != null) {
                          return DeepLink.path(initialDeepLink);
                        } else {
                          return DeepLink.single(
                            const SplashRoute(),
                          );
                        }
                      }
                    },
                    navigatorObservers: () => [
                      AutoRouteObserver(),
                      AppRouteObserver(),
                      // Other navigators will go here
                    ],
                  ),
                  builder: (context, child) {
                    final theme = Theme.of(context);
                    DjangoflowAppSnackbar.initialize(
                      snackBarTheme: theme.snackBarTheme,
                    );
                    return AppResponsiveLayoutBuilder(
                      background: Colors.black87,
                      child: SandboxBanner(
                        isSandbox:
                            appState.environment == AppEnvironment.sandbox,
                        child: child != null
                            ? kIsWeb
                                ? child
                                : AppLinksCubitListener(
                                    listenWhen: (previous, current) =>
                                        current != null,
                                    listener: (context, appLink) {
                                      final path = appLink?.path;
                                      if (path != null) {
                                        appRouter.navigateNamed(
                                          path,
                                          onFailure: (failure) {
                                            appRouter
                                                .navigate(const TasksRouter());
                                          },
                                        );
                                      }
                                    },
                                    child: AppDependencyWrapper(
                                      child: child,
                                    ),
                                  )
                            : const Offstage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );

  static void _updateErrorReporterUserInformation({
    String? id,
    String? name,
    String? email,
  }) {
    DjangoflowErrorReporter.instance
        .updateUserInformation(id: id, name: name, email: email);
  }
}

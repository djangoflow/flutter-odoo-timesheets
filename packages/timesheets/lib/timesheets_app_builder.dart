import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:djangoflow_app_links/djangoflow_app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:visibility_detector/visibility_detector.dart';

import 'configurations/router/route_observer.dart';
import 'features/app/app.dart';
import 'configurations/configurations.dart';

// project specific
class TimesheetsAppBuilder extends AppBuilder {
  TimesheetsAppBuilder({
    super.key,
    super.onDispose,
    required AppRouter appRouter,
    required AppLinksRepository appLinksRepository,
    final String? initialDeepLink,
  }) : super(
          onInitState: (context) {
            VisibilityDetectorController.instance.updateInterval =
                animationDurationShort;
          },
          repositoryProviders: [
            RepositoryProvider<AppLinksRepository>.value(
              value: appLinksRepository,
            ),
          ],
          providers: [
            BlocProvider<AppCubit>(
              create: (context) => AppCubit.instance,
            ),
            BlocProvider<AppLinksCubit>(
              create: (context) => AppLinksCubit(
                null,
                context.read<AppLinksRepository>(),
              ),
              lazy: false,
            ),
          ],
          builder: (context) => AppCubitConsumer(
            listenWhen: (previous, current) =>
                previous.environment != current.environment,
            listener: (context, state) async {},
            builder: (context, appState) => ScreenUtilInit(
              designSize: const Size(designWidth, designHeight),
              minTextAdapt: true,
              builder: (context, child) => MaterialApp.router(
                debugShowCheckedModeBanner: false,
                scaffoldMessengerKey:
                    DjangoflowAppSnackbar.scaffoldMessengerKey,
                title: appTitle,
                routeInformationParser: RouteParser(
                  appRouter.matcher,
                  includePrefixMatches: true,
                ),
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
                routerDelegate: appRouter.delegate(
                  navigatorObservers: () => [
                    AutoRouteObserver(),
                    AppRouteObserver(),
                  ],
                  initialDeepLink: initialDeepLink, // only for Android and iOS
                  // if initialDeepLink found then don't provide initialRoutes
                  initialRoutes: kIsWeb || initialDeepLink != null
                      ? null
                      : [
                          SplashRoute(backgroundColor: Colors.white),
                        ],
                ),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0.sp,
                  ),
                  child: AppResponsiveLayoutBuilder(
                    background: Container(
                      color: Colors.black87, // use theme color
                    ),
                    child: SandboxBanner(
                      isSandbox: appState.environment == AppEnvironment.sandbox,
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
                                        // onFailure: (failure) {
                                        //   appRouter
                                        //       .navigate(const TasksRouter());
                                        // },
                                      );
                                    }
                                  },
                                  child: child,
                                )
                          : const Offstage(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
}

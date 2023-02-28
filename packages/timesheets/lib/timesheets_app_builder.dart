import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:djangoflow_app_links/djangoflow_app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/app/data/odoo/app_xmlrpc_client.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/tasks/tasks.dart';
import 'package:timesheets/features/timer/timer.dart';

import 'features/app/app.dart';
import 'features/authentication/authentication.dart';
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
          onInitState: (context) {},
          repositoryProviders: [
            RepositoryProvider<AppLinksRepository>.value(
              value: appLinksRepository,
            ),
            RepositoryProvider<AppXmlRpcClient>(
              create: (context) => AppXmlRpcClient(),
            ),
            RepositoryProvider<AuthenticationRepository>(
              create: (context) => AuthenticationRepository(
                context.read<AppXmlRpcClient>(),
              ),
            ),
            RepositoryProvider<ProjectRepository>(
              create: (context) => ProjectRepository(
                context.read<AppXmlRpcClient>(),
              ),
            ),
            RepositoryProvider<TaskRepository>(
              create: (context) => TaskRepository(
                context.read<AppXmlRpcClient>(),
              ),
            ),
            RepositoryProvider<ActivityRepository>(
              create: (context) => ActivityRepository(
                context.read<AppXmlRpcClient>(),
              ),
            ),
            // provide more repositories like DjangoflowFCMRepository etc
          ],
          providers: [
            BlocProvider<AppCubit>(
              create: (context) => AppCubit.instance,
            ),
            BlocProvider<AuthCubit>(
              create: (context) => AuthCubit.instance
                ..initialize(
                  context.read<AuthenticationRepository>(),
                ),
            ),
            BlocProvider<AppLinksCubit>(
              create: (context) => AppLinksCubit(
                null,
                context.read<AppLinksRepository>(),
              ),
              lazy: false,
            ),
            BlocProvider<TaskCubit>(
              create: (context) => TaskCubit(
                context.read<TaskRepository>(),
              ),
            ),
            BlocProvider<ActivityCubit>(
              create: (context) => ActivityCubit(
                context.read<ActivityRepository>(),
              ),
            ),
            BlocProvider<TimerBloc>(
              create: (context) => TimerBloc(
                timeSheetTicker: const TimeSheetTicker(),
              ),
            ),
          ],
          builder: (context) => LoginListenerWrapper(
            initialUser: context.read<AuthCubit>().state.user,
            onLogin: (context, user) {
              final authCubit = context.read<AuthCubit>();
              final authState = authCubit.state;
              if (authState.password == null) {
                authCubit.logout();
              } else {
                context.read<AppXmlRpcClient>().updateCredentials(
                      password: authState.password,
                      id: user.id,
                      baseUrl: authState.serverUrl,
                      db: authState.db,
                    );
              }
            },
            onLogout: (context) {
              appRouter.pushAndPopUntil(
                const HomeRoute(),
                predicate: (route) => false,
              );
            },
            child: AppCubitConsumer(
              listenWhen: (previous, current) =>
                  previous.environment != current.environment,
              listener: (context, state) async {},
              builder: (context, appState) => MaterialApp.router(
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
                  initialDeepLink: initialDeepLink,
                  // only for Android and iOS
                  // if initialDeepLink found then don't provide initialRoutes
                  initialRoutes: kIsWeb || initialDeepLink != null
                      ? null
                      : [
                          SplashRoute(backgroundColor: AppColors.surface),
                        ],
                  // List of global navigation obsersers here
                  // Firebase Screen event observer
                  // SentryNavigationObserver
                  // navigatorObservers: () => {RouteObserver()},
                ),
                builder: (context, child) => AppResponsiveLayoutBuilder(
                  background: Container(
                    color: AppColors.surfaceDark,
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
                                      onFailure: (failure) {
                                        appRouter.navigate(const HomeRoute());
                                      },
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
        );
}

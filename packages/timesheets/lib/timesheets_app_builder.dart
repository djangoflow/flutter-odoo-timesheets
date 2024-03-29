import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:djangoflow_app_links/djangoflow_app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_authentication_repository.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';
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
            appRouter.authCubit = context.read<AuthCubit>();
          },
          repositoryProviders: [
            RepositoryProvider<AppDatabase>(create: (_) => AppDatabase()),
            RepositoryProvider<AppLinksRepository>.value(
              value: appLinksRepository,
            ),
            RepositoryProvider<TaskRepository>(
              create: (context) => TaskRepository(
                tasksDao: context.read<AppDatabase>().tasksDao,
                externalTasksDao: context.read<AppDatabase>().externalTasksDao,
              ),
            ),
            RepositoryProvider<TimesheetRepository>(
              create: (context) => TimesheetRepository(
                timesheetsDao: context.read<AppDatabase>().timesheetsDao,
                externalTimesheetsDao:
                    context.read<AppDatabase>().externalTimesheetsDao,
              ),
            ),
            RepositoryProvider<OdooXmlRpcClient>(
              create: (context) => OdooXmlRpcClient(),
            ),
            RepositoryProvider<OdooAuthenticationRepository>(
              create: (context) => OdooAuthenticationRepository(
                context.read<OdooXmlRpcClient>(),
              ),
            ),
            RepositoryProvider<OdooTimesheetRepository>(
              create: (context) => OdooTimesheetRepository(
                context.read<OdooXmlRpcClient>(),
              ),
            ),
            RepositoryProvider<OdooProjectRepository>(
              create: (context) => OdooProjectRepository(
                context.read<OdooXmlRpcClient>(),
              ),
            ),
            RepositoryProvider<OdooTaskRepository>(
              create: (context) => OdooTaskRepository(
                context.read<OdooXmlRpcClient>(),
              ),
            ),
            RepositoryProvider<ProjectRepository>(
              create: (context) => ProjectRepository(
                projectsDao: context.read<AppDatabase>().projectsDao,
                externalProjectsDao:
                    context.read<AppDatabase>().externalProjectsDao,
              ),
            ),
            RepositoryProvider<BackendRepository>(
              create: (context) => BackendRepository(
                context.read<AppDatabase>().backendsDao,
              ),
            ),
            RepositoryProvider<ExternalProjectRepository>(
              create: (context) => ExternalProjectRepository(
                context.read<AppDatabase>().externalProjectsDao,
              ),
            ),
            RepositoryProvider<ExternalTaskRepository>(
              create: (context) => ExternalTaskRepository(
                context.read<AppDatabase>().externalTasksDao,
              ),
            ),
            RepositoryProvider<ExternalTimesheetRepository>(
              create: (context) => ExternalTimesheetRepository(
                context.read<AppDatabase>().externalTimesheetsDao,
              ),
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
            BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(
                odooAuthenticationRepository:
                    context.read<OdooAuthenticationRepository>(),
                backendRepository: context.read<BackendRepository>(),
              ),
            ),
            BlocProvider<TaskListCubit>(
              create: (context) => TaskListCubit(
                taskRepository: context.read<TaskRepository>(),
                odooTimesheetRepository:
                    context.read<OdooTimesheetRepository>(),
              )..load(
                  const TaskListFilter(),
                ),
            )
          ],
          builder: (context) => LoginListenerWrapper(
            initialConnectedBackends:
                context.read<AuthCubit>().state.connectedBackends,
            onLogin: (context, user) {},
            child: AppCubitConsumer(
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
                    initialDeepLink:
                        initialDeepLink, // only for Android and iOS
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
                                    child: child,
                                  )
                            : const Offstage(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
}

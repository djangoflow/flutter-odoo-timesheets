import 'dart:async';

import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:djangoflow_app_links/djangoflow_app_links.dart';
import 'package:djangoflow_error_reporter/djangoflow_error_reporter.dart';
import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:djangoflow_sentry_reporter/djangoflow_sentry_reporter.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/features/authentication/data/repositories/odoo_client_repository.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/timesheets_app_builder.dart';

import 'configurations/router/odoo_auth_guard.dart';
import 'configurations/configurations.dart';
import 'utils/odoo_exception_decoder.dart';

Future<void> main() async {
  // Runs the runApp method
  DjangoflowAppRunner.run(
    onException: (exception, stackTrace) {
      // debugPrint('Exception Caught -- $exception');
      DjangoflowErrorReporter.instance.report(
        exception: exception,
        stackTrace: stackTrace,
      );

      String errorMessage = exception.toString();
      if (exception is OdooException) {
        final parsedData = extractMessageFromData(exception.message);

        errorMessage = parsedData ?? exception.message;
      } else if (exception is BackendNotAvailableException) {
        errorMessage =
            'Odoo server is not available, please check your internet connectivity.';
      }
      DjangoflowAppSnackbar.showError(
        errorMessage,
        backgroundColor:
            AppTheme.light.colorScheme.errorContainer.withOpacity(1),
      );
    },
    rootWidgetBuilder: (appBuilder) async {
      String? initialDeepLink;
      final appLinksRepository = AppLinksRepository();
      if (!kIsWeb) {
        initialDeepLink = (await appLinksRepository.getInitialLink())?.path;
      }

      if (!kDebugMode) {
        DjangoflowErrorReporter.instance.enableErrorReporting();
      }

      DjangoflowErrorReporter.instance.addAll([
        DjangoflowSentryReporter(sentryDSN),
      ]);

      final envName = AppCubit.instance.state.environment.name;
      DjangoflowErrorReporter.instance.initialize(
        env: envName,
        release: AppCubit.packageInfo?.appVersionWithPackageName,
      );

      final connectionStateProvider = ConnectionStateProvider();
      final appDatabase = AppDatabase();
      final idMappingRepository = AppIdMappingRepository(appDatabase);
      final syncRegistryRepository = AppSyncRegistryRepository(appDatabase);

      final odooClientManager = OdooClientRepository();
      final djangoflowOdooAuthRepository =
          DjangoflowOdooAuthRepository(odooClientManager);
      final authCubit = DjangoflowOdooAuthCubit(djangoflowOdooAuthRepository);
      final appRouter = AppRouter(
        odooAuthGuard: OdooAuthGuard(
          authCubit: authCubit,
        ),
      );

      // Enable this test upgrade dialog
      // await Upgrader.clearSavedSettings();

      return appBuilder(
        TimesheetsAppBuilder(
          appRouter: appRouter,
          initialDeepLink: initialDeepLink,
          providers: [
            Provider<AppDatabase>.value(value: appDatabase),
            ChangeNotifierProvider<ConnectionStateProvider>.value(
                value: connectionStateProvider),
            ChangeNotifierProvider<SmallSyncOverlayController>(
              create: (context) => SmallSyncOverlayController(),
            ),
            Provider<AppIdMappingRepository>.value(value: idMappingRepository),
            Provider<AppSyncRegistryRepository>.value(
                value: syncRegistryRepository),
            Provider<OdooClientRepository>.value(value: odooClientManager),
          ],
          blocProviders: [
            BlocProvider<AppCubit>(
              create: (_) => AppCubit.instance,
            ),
            BlocProvider<DjangoflowOdooAuthCubit>(
              create: (_) => authCubit,
            ),
            BlocProvider<AppLinksCubit>(
              create: (context) => AppLinksCubit(
                null,
                appLinksRepository,
              ),
              lazy: false,
            ),
            BlocProvider<SyncBackendCubit>(
              create: (context) => SyncBackendCubit(
                SyncBackendsRepository(
                  appDatabase,
                ),
              ),
            ),
            BlocProvider<LastAutoSyncCubit>(
              create: (context) => LastAutoSyncCubit(),
            ),
          ],
        ),
      );
    },
  );
}

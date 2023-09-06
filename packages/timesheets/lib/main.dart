import 'dart:async';

import 'package:dio/dio.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:djangoflow_app_links/djangoflow_app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'timesheets_app_builder.dart';
import 'configurations/configurations.dart';

Future<void> main() async {
  // Runs the runApp method
  DjangoflowAppRunner.run(
    onException: (exception, stackTrace) {
      debugPrint('Exception Caught -- $exception');
      String errorMessage = exception.toString();
      if (exception is DioException) {
        errorMessage = exception.message ?? 'Something went wrong!';
      }
      DjangoflowAppSnackbar.showError(errorMessage);
    },
    rootWidgetBuilder: (appBuilder) async {
      Paint.enableDithering = true;
      String? initialDeepLink;
      final appLinksRepository = AppLinksRepository();
      if (!kIsWeb) {
        initialDeepLink = (await appLinksRepository.getInitialLink())?.path;
      }

      // initialize router
      final router = AppRouter();

      // Enable this test upgrade dialog
      // await Upgrader.clearSavedSettings();

      return appBuilder(
        TimesheetsAppBuilder(
          appRouter: router,
          initialDeepLink: initialDeepLink,
          appLinksRepository: appLinksRepository,
        ),
      );
    },
  );
}

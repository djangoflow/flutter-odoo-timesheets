import 'dart:io';

import 'package:timesheets/features/authentication/authentication.dart';
import 'package:dio/dio.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (AppCubit.instance.state.locale.isNotEmpty) {
      options.headers['Accept-Language'] = AppCubit.instance.state.locale;
    }
    if (AuthCubit.instance.state.token != null) {
      options.headers['Authorization'] =
          'Bearer ${AuthCubit.instance.state.token}';
    }
    if (!kIsWeb) {
      options.headers['User-Agent'] =
          '${AppCubit.packageInfo?.packageName}/${AppCubit.packageInfo?.version}';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.type == DioErrorType.response) {
      if (err.response != null) {
        if (err.response!.statusCode == 503) {
          err.error = 'Server maintenance - try again later';
        } else if (err.response!.statusCode! >= 400 &&
            err.response!.statusCode! < 500) {
          final response = err.response;

          final errors = <Error>[];

          // Logout on authentication erorr
          if (err.response?.statusCode == 401) {
            AuthCubit.instance.logout();
          }

          if (err.response!.statusCode! == 404) {
            errors.add(
              Error(
                message: 'Not found',
                code: 'not_found',
              ),
            );
          } else {
            for (final e in response?.data['errors']) {
              if (e['message'] is String) {
                errors.add(
                  Error(
                    message: e['message'],
                    code: e['code'],
                    field: e['field'],
                  ),
                );
              }
            }
          }
          final data = ErrorResponse(
            errors: errors,
          );

          err
            ..error = errors.first.message
            ..response = Response<ErrorResponse>(
              data: data,
              headers: response?.headers,
              requestOptions: response!.requestOptions,
              redirects: response.redirects,
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              extra: response.extra,
            );
        } else if (err.response?.statusCode == 500) {
          err.error = 'Server fault - work in progress';
        }
      } else {
        err.error = 'Server unreachable';
      }
    } else if (err.type == DioErrorType.connectTimeout ||
        err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.sendTimeout) {
      err.error = 'Server connection timed out - check your connection';
    } else if (err.type == DioErrorType.other && err.error is SocketException) {
      err.error = 'You seem to be offline';
    }
    handler.next(err);
  }
}
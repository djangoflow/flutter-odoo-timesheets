import 'package:freezed_annotation/freezed_annotation.dart';

class OdooNullValueJsonConverter<T> implements JsonConverter<T?, Object?> {
  const OdooNullValueJsonConverter();

  @override
  T? fromJson(Object? json) {
    if (json is bool && json == false) {
      return null;
    } else {
      if (T is DateTime) {
        return DateTime.parse(json as String) as T;
      } else {
        return json as T;
      }
    }
  }

  @override
  Object? toJson(T? object) => object;

  static T? fromJsonOrNull<T>(Object? json) {
    const T? typeCheckValue = null;

    if (json is bool && json == false) {
      return null;
    } else {
      if (typeCheckValue is DateTime?) {
        return DateTime.parse(json as String) as T;
      } else {
        return json as T;
      }
    }
  }

  static Object? toJsonOrNull<T>(T? object) {
    if (object is DateTime?) {
      return object?.toIso8601String();
    } else {
      return object?.toString();
    }
  }
}

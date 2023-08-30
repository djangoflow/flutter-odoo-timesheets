import 'package:freezed_annotation/freezed_annotation.dart';

class OdooNullableStringJsonConverter
    implements JsonConverter<String?, Object?> {
  const OdooNullableStringJsonConverter();

  @override
  String? fromJson(Object? json) {
    if (json is bool && json == false) {
      return null;
    } else {
      return json as String;
    }
  }

  @override
  Object? toJson(String? object) => object;

  static String? fromJsonOrNull(Object? json) {
    if (json is bool && json == false) {
      return null;
    } else {
      return json as String;
    }
  }

  static Object? toJsonOrNull(String? object) => object;
}

class OdooNullableDateTimeJsonConverter
    implements JsonConverter<DateTime?, Object?> {
  const OdooNullableDateTimeJsonConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json is bool && json == false) {
      return null;
    } else {
      return DateTime.tryParse(json as String);
    }
  }

  @override
  Object? toJson(DateTime? object) => object?.toIso8601String();

  static DateTime? fromJsonOrNull(Object? json) {
    if (json is bool && json == false) {
      return null;
    } else {
      return DateTime.tryParse(json as String);
    }
  }

  static Object? toJsonOrNull(DateTime? object) => object?.toIso8601String();
}

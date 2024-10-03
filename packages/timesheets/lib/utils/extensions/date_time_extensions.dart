import 'package:intl/intl.dart';

extension DateTimeFormatExtensions on DateTime {
  String toDateString({String delimeter = '/'}) =>
      DateFormat('dd${delimeter}MM${delimeter}yyyy').format(this);
  String toDayString() => DateFormat('EEEE').format(this);

  String toTimeString() => DateFormat('HH:mm').format(this);
}

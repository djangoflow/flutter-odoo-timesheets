import 'package:flutter/material.dart';
import 'package:timesheets/features/app/app.dart';

extension ProjectColorExtensions on int? {
  Color get toColorFromColorIndex => OdooColors.fromIndex(this ?? 0).color;

  OdooColors get toOdooColorFromColorIndex => OdooColors.fromIndex(this ?? 0);
}

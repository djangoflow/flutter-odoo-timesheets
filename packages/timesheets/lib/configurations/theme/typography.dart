import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

class AppTextStyle {
  static TextStyle get _baseTextStyle => const TextStyle(
        fontFamily: appFontFamily,
      );
  static TextStyle get displayLarge => _baseTextStyle.copyWith(
        fontSize: 57,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 64 / 57,
        letterSpacing: 0,
      );

  static TextStyle get displayMedium => _baseTextStyle.copyWith(
        fontSize: 45,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 52 / 45,
        letterSpacing: 0,
      );

  static TextStyle get displaySmall => _baseTextStyle.copyWith(
        fontSize: 36,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 44 / 36,
        letterSpacing: 0,
      );

  static TextStyle get headlineLarge => _baseTextStyle.copyWith(
        fontSize: 32,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: 0,
      );

  static TextStyle get headlineMedium => _baseTextStyle.copyWith(
        fontSize: 28,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 36 / 28,
        letterSpacing: 0,
      );

  static TextStyle get headlineSmall => _baseTextStyle.copyWith(
        fontSize: 24,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        letterSpacing: 0,
      );

  static TextStyle get titleLarge => _baseTextStyle.copyWith(
        fontSize: 22,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 28 / 22,
        letterSpacing: 0,
      );

  static TextStyle get titleMedium => _baseTextStyle.copyWith(
        fontSize: 16,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => _baseTextStyle.copyWith(
        fontSize: 14,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 0.1,
      );

  static TextStyle get labelLarge => _baseTextStyle.copyWith(
        fontSize: 14,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => _baseTextStyle.copyWith(
        fontSize: 12,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => _baseTextStyle.copyWith(
        fontSize: 11,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        height: 16 / 11,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
        fontSize: 16,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
        fontSize: 14,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => _baseTextStyle.copyWith(
        fontSize: 12,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        letterSpacing: 0.4,
      );

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
      );
}

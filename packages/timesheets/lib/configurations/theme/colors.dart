import 'package:flutter/material.dart';

class AppColors {
  /// ColorScheme for dark theme
  static ColorScheme get darkThemeColorScheme => const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: darkThemePrimary,
        onPrimary: darkThemeOnPrimary,
        primaryContainer: darkThemePrimaryContainer,
        onPrimaryContainer: darkThemeOnPrimaryContainer,
        secondary: darkThemeSecondary,
        onSecondary: darkThemeOnSecondary,
        secondaryContainer: darkThemeSecondaryContainer,
        onSecondaryContainer: darkThemeOnSecondaryContainer,
        tertiary: darkThemeTertiary,
        onTertiary: darkThemeOnTertiary,
        tertiaryContainer: darkThemeTertiaryContainer,
        onTertiaryContainer: darkThemeOnTertiaryContainer,
        error: darkThemeError,
        onError: darkThemeOnError,
        errorContainer: darkThemeErrorContainer,
        onErrorContainer: darkThemeOnErrorContainer,
        surface: darkThemeSurface,
        onSurface: darkThemeOnSurface,
        surfaceVariant: darkThemeSurfaceVariant,
        onSurfaceVariant: darkThemeOnSurfaceVariant,
        outline: darkThemeOutline,
        outlineVariant: darkThemeOutlinevariant,
        background: darkThemeBackground,
        onBackground: darkThemeOnBackground,
        shadow: Colors.transparent,
        surfaceTint: Colors.white,
      );

  /// ColorScheme for light theme
  static ColorScheme get lightThemeColorScheme => const ColorScheme.light(
        brightness: Brightness.light,
        primary: lightThemePrimary,
        onPrimary: lightThemeOnPrimary,
        primaryContainer: lightThemePrimaryContainer,
        onPrimaryContainer: lightThemeOnPrimaryContainer,
        secondary: lightThemeSecondary,
        onSecondary: lightThemeOnSecondary,
        secondaryContainer: lightThemeSecondaryContainer,
        onSecondaryContainer: lightThemeOnSecondaryContainer,
        tertiary: lightThemeTertiary,
        onTertiary: lightThemeOnTertiary,
        tertiaryContainer: lightThemeTertiaryContainer,
        onTertiaryContainer: lightThemeOnTertiaryContainer,
        error: lightThemeError,
        onError: lightThemeOnError,
        errorContainer: lightThemeErrorContainer,
        onErrorContainer: lightThemeOnErrorContainer,
        surface: lightThemeSurface,
        onSurface: lightThemeOnSurface,
        surfaceVariant: lightThemeSurfaceVariant,
        onSurfaceVariant: lightThemeOnSurfaceVariant,
        outline: lightThemeOutline,
        outlineVariant: lightThemeOutlinevariant,
        background: lightThemeBackground,
        onBackground: lightThemeOnBackground,
        shadow: Colors.transparent,
        surfaceTint: Colors.white,
      );

  // Dark theme colors
  static const Color darkThemePrimary = Color(0xff000000);
  static const Color darkThemeOnPrimary = Color(0xffffffff);
  static const Color darkThemePrimaryContainer = Color(0xff000000);
  static const Color darkThemeOnPrimaryContainer = Color(0xffffffff);
  static const Color darkThemeSecondary = Color(0x29ffffff);
  static const Color darkThemeOnSecondary = Color(0xffffffff);
  static const Color darkThemeSecondaryContainer = Color(0x3dffffff);
  static const Color darkThemeOnSecondaryContainer = Color(0xffffffff);
  static const Color darkThemeTertiary = Color(0x52ffffff);
  static const Color darkThemeOnTertiary = Color(0xffffffff);
  static const Color darkThemeTertiaryContainer = Color(0x7affffff);
  static const Color darkThemeOnTertiaryContainer = Color(0xffffffff);
  static const Color darkThemeError = Color(0xffcc3c21);
  static const Color darkThemeOnError = Color(0xffffffff);
  static const Color darkThemeErrorContainer = Color(0x52cc3c21);
  static const Color darkThemeOnErrorContainer = Color(0xffcc3c21);
  static const Color darkThemeBackground = Color(0xff000000);
  static const Color darkThemeOnBackground = Color(0xffffffff);
  static const Color darkThemeSurface = Color(0xFF292929);
  static const Color darkThemeOnSurface = Color(0xffffffff);
  static const Color darkThemeSurfaceVariant = Color(0xff000000);
  static const Color darkThemeOnSurfaceVariant = Color(0xffffffff);
  static const Color darkThemeOutline = Color(0x29ffffff);
  static const Color darkThemeOutlinevariant = Color(0x7affffff);

  // Light theme colors
  static const Color lightThemePrimary = Color(0xffffffff);
  static const Color lightThemeOnPrimary = Color(0xff000000);
  static const Color lightThemePrimaryContainer = Color(0xffffffff);
  static const Color lightThemeOnPrimaryContainer = Color(0xff000000);
  static const Color lightThemeSecondary = Color(0x29ffffff);
  static const Color lightThemeOnSecondary = Color(0xffffffff);
  static const Color lightThemeSecondaryContainer = Color(0x29ffffff);
  static const Color lightThemeOnSecondaryContainer = Color(0xffffffff);
  static const Color lightThemeTertiary = Color(0x52ffffff);
  static const Color lightThemeOnTertiary = Color(0xff000000);
  static const Color lightThemeTertiaryContainer = Color(0x52ffffff);
  static const Color lightThemeOnTertiaryContainer = Color(0xff000000);
  static const Color lightThemeSurface = Color(0xFF214ECC);
  static const Color lightThemeOnSurface = Color(0xffffffff);
  static const Color lightThemeSurfaceVariant = Color(0xFF0C1D4D);
  static const Color lightThemeOnSurfaceVariant = Color(0xffffffff);
  static const Color lightThemeBackground = Color(0xFF214ECC);
  static const Color lightThemeOnBackground = Color(0xffffffff);
  static const Color lightThemeError = Color(0xffcc3c21);
  static const Color lightThemeOnError = Color(0xffffffff);
  static const Color lightThemeErrorContainer = Color(0x52cc3c21);
  static const Color lightThemeOnErrorContainer = Color(0xffcc3c21);
  static const Color lightThemeOutline = Color(0x29ffffff);
  static const Color lightThemeOutlinevariant = Color(0x7affffff);
}

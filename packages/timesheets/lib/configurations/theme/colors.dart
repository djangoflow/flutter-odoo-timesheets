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
      );

  // Dark theme colors
  static const Color darkThemePrimary = Color(0xffffffff);
  static const Color darkThemeOnPrimary = Color(0xff000000);
  static const Color darkThemePrimaryContainer = Color(0xff141414);
  static const Color darkThemeOnPrimaryContainer = Color(0xffffffff);
  static const Color darkThemeSecondary = Color(0xff00007a);
  static const Color darkThemeOnSecondary = Color(0xffffffff);
  static const Color darkThemeSecondaryContainer = Color(0xff00003d);
  static const Color darkThemeOnSecondaryContainer = Color(0xffffffff);
  static const Color darkThemeTertiary = Color(0xff006e6e);
  static const Color darkThemeOnTertiary = Color(0xffffffff);
  static const Color darkThemeTertiaryContainer = Color(0xff003737);
  static const Color darkThemeOnTertiaryContainer = Color(0xffffffff);
  static const Color darkThemeError = Color(0xff7a0000);
  static const Color darkThemeOnError = Color(0xffffffff);
  static const Color darkThemeErrorContainer = Color(0xff3d0000);
  static const Color darkThemeOnErrorContainer = Color(0xffffffff);
  static const Color darkThemeSurface = Color(0xff000000);
  static const Color darkThemeOnSurface = Color(0xffffffff);
  static const Color darkThemeSurfaceVariant = Color(0xff141414);
  static const Color darkThemeOnSurfaceVariant = Color(0xff7a7a7a);
  static const Color darkThemeOutline = Color(0xff292929);
  static const Color darkThemeOutlinevariant = Color(0xff3d3d3d);
  static const Color darkThemeBackground = Color(0xff000000);
  static const Color darkThemeOnBackground = Color(0xffffffff);

  // Light theme colors
  static const Color lightThemePrimary = Color(0xff000000);
  static const Color lightThemeOnPrimary = Color(0xffffffff);
  static const Color lightThemePrimaryContainer = Color(0xffebebeb);
  static const Color lightThemeOnPrimaryContainer = Color(0xff000000);
  static const Color lightThemeSecondary = Color(0xff0000ff);
  static const Color lightThemeOnSecondary = Color(0xffffffff);
  static const Color lightThemeSecondaryContainer = Color(0xff8585ff);
  static const Color lightThemeOnSecondaryContainer = Color(0xffffffff);
  static const Color lightThemeTertiary = Color(0xff00e6e6);
  static const Color lightThemeOnTertiary = Color(0xffffffff);
  static const Color lightThemeTertiaryContainer = Color(0xff85f3f3);
  static const Color lightThemeOnTertiaryContainer = Color(0xffffffff);
  static const Color lightThemeError = Color(0xffff0000);
  static const Color lightThemeOnError = Color(0xffffffff);
  static const Color lightThemeErrorContainer = Color(0xffff8585);
  static const Color lightThemeOnErrorContainer = Color(0xffffffff);
  static const Color lightThemeSurface = Color(0xffffffff);
  static const Color lightThemeOnSurface = Color(0xff000000);
  static const Color lightThemeSurfaceVariant = Color(0xffebebeb);
  static const Color lightThemeOnSurfaceVariant = Color(0xff858585);
  static const Color lightThemeOutline = Color(0xffebebeb);
  static const Color lightThemeOutlinevariant = Color(0xffd6d6d6);
  static const Color lightThemeOnBackground = Color(0xff000000);
  static const Color lightThemeBackground = Color(0xffffffff);
}

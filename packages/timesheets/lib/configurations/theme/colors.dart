import 'package:flutter/material.dart';

class AppColors {
  static ColorScheme get getLightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      );

  static ColorScheme get getDarkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryDark,
        onPrimary: onPrimaryDark,
        primaryContainer: primaryContainerDark,
        onPrimaryContainer: onPrimaryContainerDark,
        secondary: secondaryDark,
        onSecondary: onSecondaryDark,
        secondaryContainer: secondaryContainerDark,
        onSecondaryContainer: onSecondaryContainerDark,
        tertiary: tertiaryDark,
        onTertiary: onTertiaryDark,
        tertiaryContainer: tertiaryContainerDark,
        onTertiaryContainer: onTertiaryContainerDark,
        error: errorDark,
        onError: onErrorDark,
        errorContainer: errorContainerDark,
        onErrorContainer: onErrorContainerDark,
        background: backgroundDark,
        onBackground: onBackgroundDark,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        onSurfaceVariant: onSurfaceVariantDark,
        outline: outlineDark,
        outlineVariant: outlineVariantDark,
      );

  // Light theme colors
  static const Color primary = Color(0xff000000);
  static const Color onPrimary = Color(0xffFFFFFF);
  static const Color primaryContainer = Color(0xffEBEBEB);
  static const Color onPrimaryContainer = Color(0xff000000);
  static const Color background = Color(0xffFFFFFF);
  static const Color onBackground = Color(0xff000000);
  static const Color secondary = Color(0xff0000ff);
  static const Color onSecondary = Color(0xffFFFFFF);
  static const Color secondaryContainer = Color(0xff8585FF);
  static const Color onSecondaryContainer = Color(0xffFFFFFF);
  static const Color surface = Color(0xffFFFFFF);
  static const Color surfaceVariant = Color(0xffEBEBEB);
  static const Color onSurface = Color(0xff000000);
  static const Color onSurfaceVariant = Color(0xff858585);
  static const Color tertiary = Color(0xff00E6E6);
  static const Color onTertiary = Color(0xffFFFFFF);
  static const Color tertiaryContainer = Color(0xff85F3F3);
  static const Color onTertiaryContainer = Color(0xffFFFFFF);
  static const Color error = Color(0xffFF0000);
  static const Color onError = Color(0xffFFFFFF);
  static const Color errorContainer = Color(0xffFF8585);
  static const Color onErrorContainer = Color(0xffFFFFFF);
  static const Color outline = Color(0xffEBEBEB);
  static const Color outlineVariant = Color(0xffD6D6D6);

  // Dark theme colors
  static const Color primaryDark = Color(0xffFFFFFF);
  static const Color onPrimaryDark = Color(0xff000000);
  static const Color primaryContainerDark = Color(0xff141414);
  static const Color onPrimaryContainerDark = Color(0xffFFFFFF);
  static const Color backgroundDark = Color(0xff000000);
  static const Color onBackgroundDark = Color(0xffFFFFFF);
  static const Color secondaryDark = Color(0xff00007A);
  static const Color onSecondaryDark = Color(0xffFFFFFF);
  static const Color secondaryContainerDark = Color(0xff00003D);
  static const Color onSecondaryContainerDark = Color(0xffFFFFFF);
  static const Color surfaceDark = Color(0xff000000);
  static const Color surfaceVariantDark = Color(0xff141414);
  static const Color onSurfaceDark = Color(0xffFFFFFF);
  static const Color onSurfaceVariantDark = Color(0xff7A7A7A);
  static const Color tertiaryDark = Color(0xff006E6E);
  static const Color onTertiaryDark = Color(0xffFFFFFF);
  static const Color tertiaryContainerDark = Color(0xff003737);
  static const Color onTertiaryContainerDark = Color(0xffFFFFFF);
  static const Color errorDark = Color(0xff7A0000);
  static const Color onErrorDark = Color(0xffFFFFFF);
  static const Color errorContainerDark = Color(0xff3D0000);
  static const Color onErrorContainerDark = Color(0xffFFFFFF);
  static const Color outlineDark = Color(0xff292929);
  static const Color outlineVariantDark = Color(0xff3D3D3D);
}

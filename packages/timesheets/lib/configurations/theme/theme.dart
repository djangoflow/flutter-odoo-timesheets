import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'size_constants.dart';
import 'typography.dart';

export 'colors.dart';
export 'size_constants.dart';
export 'typography.dart';

class AppTheme {
  static const double _buttonRadius = 10;
  // Shared sub theme data for light, darktheme.
  static FlexSubThemesData get _commonSubThemeData => FlexSubThemesData(
        buttonPadding: const EdgeInsets.symmetric(
          horizontal: kPadding * 2,
          vertical: kPadding * 2,
        ),
        elevatedButtonRadius: _buttonRadius,
        textButtonRadius: _buttonRadius,
        outlinedButtonRadius: _buttonRadius,
        filledButtonRadius: _buttonRadius,
        inputDecoratorRadius: _buttonRadius,
        elevatedButtonTextStyle:
            MaterialStateProperty.all(AppTextStyle.titleMedium),
        textButtonTextStyle:
            MaterialStateProperty.all(AppTextStyle.titleMedium),
        outlinedButtonTextStyle:
            MaterialStateProperty.all(AppTextStyle.titleMedium),
        filledButtonTextStyle:
            MaterialStateProperty.all(AppTextStyle.titleMedium),
        elevatedButtonSchemeColor: SchemeColor.onPrimary,
        elevatedButtonSecondarySchemeColor: SchemeColor.primary,
        outlinedButtonOutlineSchemeColor: SchemeColor.primary,
        checkboxSchemeColor: SchemeColor.primary,
        inputDecoratorSchemeColor: SchemeColor.tertiary,
        inputDecoratorIsFilled: false,
        fabSchemeColor: SchemeColor.primary,
        chipSchemeColor: SchemeColor.primary,
        cardElevation: 3,
      );

  static ThemeData get light {
    final colorScheme = AppColors.lightThemeColorScheme;
    final theme = FlexThemeData.light(
      colorScheme: colorScheme,
      textTheme: AppTextStyle.textTheme,
      primaryTextTheme: AppTextStyle.primaryTextTheme(colorScheme.onPrimary),
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      useMaterial3ErrorColors: true,
      subThemesData: _commonSubThemeData,
    );

    return theme;
  }

  static ThemeData get dark {
    final colorScheme = AppColors.darkThemeColorScheme;
    final theme = FlexThemeData.dark(
      colorScheme: colorScheme,
      textTheme: AppTextStyle.textTheme,
      primaryTextTheme: AppTextStyle.primaryTextTheme(colorScheme.onPrimary),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      useMaterial3ErrorColors: true,
      subThemesData: _commonSubThemeData,
    );
    return theme;
  }
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'size_constants.dart';
import 'typography.dart';

export 'colors.dart';
export 'size_constants.dart';
export 'typography.dart';

class AppTheme {
  static const double _buttonRadius = 10;
  // Shared sub theme data for light, darktheme.
  static FlexSubThemesData get _commonSubThemeData {
    final buttonTextStyle = AppTextStyle.titleMedium.copyWith(
      height: 1,
    );
    return FlexSubThemesData(
      buttonPadding: EdgeInsets.symmetric(
        horizontal: kPadding.w * 2,
        vertical: kPadding.h * 2.5,
      ),
      elevatedButtonRadius: _buttonRadius,
      textButtonRadius: _buttonRadius,
      outlinedButtonRadius: _buttonRadius,
      filledButtonRadius: _buttonRadius,
      inputDecoratorRadius: _buttonRadius,
      elevatedButtonTextStyle: MaterialStateProperty.all(buttonTextStyle),
      textButtonTextStyle: MaterialStateProperty.all(buttonTextStyle),
      outlinedButtonTextStyle: MaterialStateProperty.all(buttonTextStyle),
      filledButtonTextStyle: MaterialStateProperty.all(buttonTextStyle),
      elevatedButtonSchemeColor: SchemeColor.onPrimary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primary,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      checkboxSchemeColor: SchemeColor.primary,
      inputDecoratorSchemeColor: SchemeColor.tertiary,
      inputDecoratorIsFilled: false,
      fabSchemeColor: SchemeColor.primary,
      chipSchemeColor: SchemeColor.primary,
      cardElevation: 3,
      cardRadius: kPadding.r * 2,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
    );
  }

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

    return applyCommonTheme(theme);
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
    return applyCommonTheme(theme);
  }

  static ThemeData applyCommonTheme(ThemeData theme) {
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return theme.copyWith(
      listTileTheme: theme.listTileTheme.copyWith(
        tileColor: theme.colorScheme.primaryContainer,
        contentPadding: EdgeInsets.symmetric(
          horizontal: kPadding.w * 2,
          vertical: kPadding.h,
        ),
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPadding.r),
        ),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        contentPadding: EdgeInsets.symmetric(
          horizontal: kPadding.w * 2,
          vertical: kPadding.h * 2,
        ),
      ),
      tabBarTheme: theme.tabBarTheme.copyWith(
        labelStyle: textTheme.labelLarge,
      ),
    );
  }
}

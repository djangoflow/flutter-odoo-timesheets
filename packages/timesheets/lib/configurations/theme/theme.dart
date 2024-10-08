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
      elevatedButtonTextStyle: WidgetStateProperty.all(buttonTextStyle),
      textButtonTextStyle: WidgetStateProperty.all(buttonTextStyle),
      outlinedButtonTextStyle: WidgetStateProperty.all(buttonTextStyle),
      filledButtonTextStyle: WidgetStateProperty.all(buttonTextStyle),
      elevatedButtonSchemeColor: SchemeColor.onSecondaryContainer,
      elevatedButtonSecondarySchemeColor: SchemeColor.secondaryContainer,
      textButtonSchemeColor: SchemeColor.onSecondaryContainer,
      outlinedButtonSchemeColor: SchemeColor.onSecondaryContainer,
      checkboxSchemeColor: SchemeColor.primary,
      inputDecoratorSchemeColor: SchemeColor.tertiary,
      inputDecoratorIsFilled: false,
      fabSchemeColor: SchemeColor.primary,
      chipSchemeColor: SchemeColor.primary,
      cardRadius: kPadding.r * 2,
      cardElevation: 4,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      bottomNavigationBarBackgroundSchemeColor: SchemeColor.surface,
      bottomNavigationBarElevation: 0,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.onSurfaceVariant,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.onSurfaceVariant,
      bottomNavigationBarUnselectedIconSchemeColor:
          SchemeColor.onSurfaceVariant,
      bottomNavigationBarUnselectedLabelSchemeColor:
          SchemeColor.onSurfaceVariant,
      appBarBackgroundSchemeColor: SchemeColor.surfaceVariant,
      appBarScrolledUnderElevation: 0,
      tabBarIndicatorSchemeColor: SchemeColor.onSurfaceVariant,
      tabBarItemSchemeColor: SchemeColor.onSurfaceVariant,
      tabBarUnselectedItemOpacity: 0.5,
    );
  }

  static ThemeData get light {
    final colorScheme = AppColors.lightThemeColorScheme;
    final theme = FlexThemeData.light(
      colorScheme: colorScheme,
      textTheme: AppTextStyle.textTheme,
      blendLevel: 0,
      primaryTextTheme: AppTextStyle.primaryTextTheme(colorScheme.onPrimary),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      useMaterial3ErrorColors: false,
      subThemesData: _commonSubThemeData,
      scaffoldBackground: colorScheme.surfaceVariant,
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
      blendLevel: 0,
      useMaterial3ErrorColors: false,
      scaffoldBackground: colorScheme.surfaceVariant,
      subThemesData: _commonSubThemeData,
    );

    return applyCommonTheme(theme);
  }

  static ThemeData applyCommonTheme(ThemeData theme) {
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return theme.copyWith(
      listTileTheme: theme.listTileTheme.copyWith(
        tileColor: AppColors.getTintedSurfaceColor(colorScheme.surfaceTint),
        minLeadingWidth: kPadding.w / 4,
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
      expansionTileTheme: theme.expansionTileTheme.copyWith(
        backgroundColor:
            AppColors.getTintedSurfaceColor(colorScheme.surfaceTint),
        tilePadding: EdgeInsets.symmetric(
          vertical: kPadding.h,
          horizontal: kPadding.w * 2,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPadding.r),
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
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.tertiary,
        ),
        filled: true,
        fillColor: colorScheme.secondaryContainer,
        floatingLabelStyle: textTheme.labelLarge,
      ),
      tabBarTheme: theme.tabBarTheme.copyWith(
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge,
      ),
      cardTheme: theme.cardTheme.copyWith(
        color: Colors.transparent,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPadding),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: theme.iconButtonTheme.style?.copyWith(
          iconSize: WidgetStatePropertyAll(kPadding.h * 3),
        ),
      ),
      iconTheme: theme.iconTheme.copyWith(
        color: theme.colorScheme.onSecondary,
      ),
      progressIndicatorTheme: theme.progressIndicatorTheme.copyWith(
        color: theme.colorScheme.tertiary,
        linearTrackColor: theme.colorScheme.tertiaryContainer,
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        color: theme.colorScheme.outline,
        thickness: 1,
      ),
      snackBarTheme: theme.snackBarTheme.copyWith(
        contentTextStyle: theme.textTheme.bodyMedium,
        actionTextColor: theme.colorScheme.primary,
        actionBackgroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.onPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPadding * 2),
        ),
      ),
    );
  }

  static IconButtonThemeData getFilledIconButtonTheme(ThemeData theme) =>
      IconButtonThemeData(
        style: theme.iconButtonTheme.style?.copyWith(
          backgroundColor:
              WidgetStatePropertyAll(theme.colorScheme.secondaryContainer),
          iconSize: WidgetStatePropertyAll(kPadding.h * 3),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kPadding.r * 1.5),
            ),
          ),
        ),
      );
}

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
  static FlexSubThemesData get _commonSubThemeData {
    final buttonTextStyle = AppTextStyle.titleMedium.copyWith(
      height: 1,
    );
    return FlexSubThemesData(
      buttonPadding: const EdgeInsets.symmetric(
        horizontal: kPadding * 2,
        vertical: kPadding * 2.5,
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
      cardRadius: kPadding * 2,
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
        minLeadingWidth: kPadding / 4,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kPadding * 2,
          vertical: kPadding,
        ),
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPadding),
        ),
      ),
      expansionTileTheme: theme.expansionTileTheme.copyWith(
        backgroundColor:
            AppColors.getTintedSurfaceColor(colorScheme.surfaceTint),
        tilePadding: const EdgeInsets.symmetric(
          vertical: kPadding,
          horizontal: kPadding * 2,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPadding),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPadding),
        ),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kPadding * 2,
          vertical: kPadding * 2,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.tertiary,
        ),
        filled: true,
        fillColor: colorScheme.secondaryContainer,
        floatingLabelStyle: textTheme.labelLarge,
        hoverColor: colorScheme.primary.withOpacity(0.1),
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
          iconSize: const WidgetStatePropertyAll(kPadding * 3),
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
          iconSize: const WidgetStatePropertyAll(kPadding * 3),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kPadding * 1.5),
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import 'package:timesheets/configurations/configurations.dart';

class AppModalSheet extends StatelessWidget {
  const AppModalSheet({super.key});
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: false,
      barrierColor: colorScheme.surfaceVariant.withOpacity(.24),
      backgroundColor: colorScheme.surface.withOpacity(.6),
      elevation: 0,
      builder: (context) => GlassContainer(
        blur: kDefaultBlur,
        shadowStrength: 0,
        color: AppColors.getTintedSurfaceColor(colorScheme.surfaceTint),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kPadding.r * 2),
        ),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const Placeholder();
}

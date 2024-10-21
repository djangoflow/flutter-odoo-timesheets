import 'package:flutter/material.dart';

import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:timesheets/configurations/configurations.dart';

class AppGlassContainer extends StatelessWidget {
  const AppGlassContainer({super.key, required this.child, this.borderRadius});
  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) => GlassContainer(
        blur: kDefaultBlur,
        shadowStrength: 0,
        color: AppColors.getTintedSurfaceColor(
            Theme.of(context).colorScheme.surfaceTint),
        borderRadius: borderRadius ??
            const BorderRadius.all(
              Radius.circular(kPadding),
            ),
        child: child,
      );
}

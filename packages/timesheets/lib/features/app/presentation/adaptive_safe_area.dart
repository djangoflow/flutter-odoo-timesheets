import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

class AdaptiveSafeArea extends StatelessWidget {
  const AdaptiveSafeArea({
    super.key,
    required this.child,
    this.minimumPadding = const EdgeInsets.only(bottom: kPadding * 3),
  });

  final Widget child;
  final EdgeInsets minimumPadding;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safePadding = mediaQuery.padding;
    final safeViewInsets = mediaQuery.viewInsets;

    return SafeArea(
      bottom: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: math.max(
            minimumPadding.bottom,
            safePadding.bottom + safeViewInsets.bottom > 0
                ? 0
                : minimumPadding.bottom,
          ),
        ),
        child: child,
      ),
    );
  }
}

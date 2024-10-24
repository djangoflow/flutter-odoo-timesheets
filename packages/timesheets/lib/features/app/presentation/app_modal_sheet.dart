import 'package:flutter/material.dart';

import 'package:timesheets/configurations/configurations.dart';

import 'app_glass_container.dart';

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
      builder: (context) => AppGlassContainer(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(kPadding * 2),
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

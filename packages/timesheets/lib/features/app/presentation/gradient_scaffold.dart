import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold(
      {super.key, required this.body, this.appBar, this.bottomNavigationBar});

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final surfaceVariant = theme.colorScheme.surfaceVariant;

    return ScaffoldGradientBackground(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [surfaceVariant, surface],
        stops: const [.15, .85],
      ),
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}

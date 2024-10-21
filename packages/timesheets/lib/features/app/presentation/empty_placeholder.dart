import 'package:flutter/material.dart';

import 'package:timesheets/configurations/configurations.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({
    super.key,
    required this.message,
    required this.icon,
    required this.title,
    this.onGetStarted,
    this.heightFactor = .65,
    this.buttonText = 'Get Started',
  });
  final Widget icon;
  final String title;
  final String message;

  final void Function()? onGetStarted;
  final String buttonText;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * heightFactor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          icon,
          const SizedBox(
            height: kPadding * 4,
          ),
          Text(
            title,
            style: textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: kPadding,
          ),
          Text(
            message,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (onGetStarted != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onGetStarted,
                child: Text(buttonText),
              ),
            ),
        ],
      ),
    );
  }
}

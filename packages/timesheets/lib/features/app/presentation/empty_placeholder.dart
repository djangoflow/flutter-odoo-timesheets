import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({
    super.key,
    required this.message,
    required this.icon,
    required this.title,
    this.onGetStarted,
    this.height = .7,
    this.buttonText = 'Get Started',
  });
  final Widget icon;
  final String title;
  final String message;

  final void Function()? onGetStarted;
  final String buttonText;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
      height: height.sh,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          icon,
          SizedBox(
            height: kPadding.h * 4,
          ),
          Text(
            title,
            style: textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: kPadding.h,
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

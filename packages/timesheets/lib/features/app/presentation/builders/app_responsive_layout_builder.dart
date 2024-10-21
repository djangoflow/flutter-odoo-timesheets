import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:timesheets/configurations/configurations.dart';

class AppResponsiveLayoutBuilder extends StatelessWidget {
  const AppResponsiveLayoutBuilder({
    required this.child,
    required this.background,
    super.key,
    this.breakpoints = defaultBreakpoints,
    this.maxWidth = maxScreenWidth,
  });

  final Widget child;
  final List<Breakpoint> breakpoints;
  final double maxWidth;
  final Color background;

  @override
  Widget build(BuildContext context) => ResponsiveBreakpoints.builder(
        child: _ResponsiveLayout(
          maxWidth: maxWidth,
          background: background,
          child: child,
        ),
        breakpoints: breakpoints,
      );
}

class _ResponsiveLayout extends StatelessWidget {
  const _ResponsiveLayout({
    required this.child,
    required this.maxWidth,
    required this.background,
  });

  final Widget child;
  final double maxWidth;
  final Color background;

  @override
  Widget build(BuildContext context) => ClipRect(
        child: MaxWidthBox(
          maxWidth: maxWidth,
          backgroundColor: background,
          alignment: Alignment.center,
          child: Builder(
            builder: (context) => ResponsiveScaledBox(
              width: _getResponsiveWidth(context),
              child: child,
            ),
          ),
        ),
      );

  double _getResponsiveWidth(BuildContext context) => ResponsiveValue<double>(
        context,
        conditionalValues: [
          const Condition.equals(
            name: MOBILE,
            value: mobileBreakpoint,
          ),
          Condition.between(
            start: (mobileBreakpoint + 1).toInt(),
            end: maxScreenWidth.toInt(),
            value: mobileBreakpoint,
          ),
        ],
        defaultValue: mobileBreakpoint,
      ).value;
}

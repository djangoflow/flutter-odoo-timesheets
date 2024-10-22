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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withOpacity(.5),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: ResponsiveBreakpoints.builder(
        child: Stack(
          children: [
            // Decorative elements for the background
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(
                  color: theme.colorScheme.primary.withOpacity(0.4),
                ),
              ),
            ),
            // Animated circles in the background
            ...List.generate(5, (index) => _buildFloatingCircle(theme, index)),
            // The main app content
            Builder(builder: (context) {
              final isMobile = ResponsiveBreakpoints.of(context).isMobile;

              return _ResponsiveLayout(
                maxWidth: maxWidth,
                background: Colors.transparent,
                child: Container(
                  // Add a subtle shadow to the main app container
                  decoration: isMobile
                      ? null
                      : BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(kPadding * 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                  clipBehavior: isMobile ? Clip.none : Clip.antiAlias,
                  child: child,
                ),
              );
            }),
          ],
        ),
        breakpoints: breakpoints,
      ),
    );
  }

  Widget _buildFloatingCircle(ThemeData theme, int index) =>
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: 3 + index),
        curve: Curves.easeInOut,
        builder: (context, double value, child) => Positioned(
          left: 100 + (index * 200) * value,
          top: 50 + (index * 100) * (1 - value),
          child: Container(
            width: 50 + (index * 20),
            height: 50 + (index * 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withOpacity(0.05),
            ),
          ),
        ),
      );
}

// Custom painter for background pattern
class BackgroundPainter extends CustomPainter {
  final Color color;

  BackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

    // Draw a grid of dots
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
  Widget build(BuildContext context) => MaxWidthBox(
        maxWidth: maxWidth,
        backgroundColor: background,
        alignment: Alignment.center,
        child: Builder(
          builder: (context) => ResponsiveScaledBox(
            width: _getResponsiveWidth(context),
            child: child,
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

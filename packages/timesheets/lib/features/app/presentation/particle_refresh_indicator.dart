import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'dart:ui';

import 'particle_animation.dart';

class ParticleRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const ParticleRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) => CustomRefreshIndicator(
        onRefresh: onRefresh,
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) =>
            Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, _) {
                final blurSigma = controller.value * 2.0;
                final shadeOpacity = controller.value * 0.2;
                return Stack(
                  children: [
                    ImageFiltered(
                      enabled: blurSigma > 0,
                      imageFilter: ImageFilter.blur(
                        sigmaX: blurSigma,
                        sigmaY: blurSigma,
                      ),
                      child: Transform.translate(
                        offset: Offset(0.0, 100.0 * controller.value),
                        child: child,
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(shadeOpacity),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            if (controller.value > 0)
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: SizedBox(
                  height: 100.0 * controller.value,
                  child: Center(
                    child: ParticleAnimation(
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 100.0 * controller.value,
                      isAnimating: controller.isLoading,
                    ),
                  ),
                ),
              ),
          ],
        ),
        child: child,
      );
}

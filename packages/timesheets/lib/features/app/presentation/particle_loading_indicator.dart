import 'package:flutter/material.dart';

import 'particle_animation.dart';

class ParticleLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const ParticleLoadingIndicator({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: ParticleAnimation(
          color: color ?? Theme.of(context).colorScheme.primary,
          size: size,
        ),
      );
}

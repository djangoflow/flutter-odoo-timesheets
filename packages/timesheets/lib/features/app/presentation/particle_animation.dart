import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticleAnimation extends StatefulWidget {
  final Color color;
  final double size;
  final bool isAnimating;

  const ParticleAnimation({
    super.key,
    required this.color,
    this.size = 100.0,
    this.isAnimating = true,
  });

  @override
  State<ParticleAnimation> createState() => _ParticleAnimationState();
}

class _ParticleAnimationState extends State<ParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ParticleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => CustomPaint(
            painter: ParticlePainter(
              animation: _controller,
              color: widget.color,
            ),
          ),
        ),
      );
}

class ParticlePainter extends CustomPainter {
  ParticlePainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;

  final List<Offset> _particlePositions = [
    const Offset(-0.5, -1.0),
    const Offset(0.5, -1.0),
    const Offset(-0.5, -0.8),
    const Offset(0.5, -0.8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(size.width, size.height) / 4;

    for (int i = 0; i < _particlePositions.length; i++) {
      final angle = animation.value * 2 * math.pi + (i * math.pi / 2);
      final particleOffset = Offset(
        centerX + math.cos(angle) * radius,
        centerY + math.sin(angle) * radius,
      );
      canvas.drawCircle(particleOffset, 6, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) =>
      animation.value != oldDelegate.animation.value ||
      color != oldDelegate.color;
}

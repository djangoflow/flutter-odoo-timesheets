import 'package:flutter/material.dart';

import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // Animation durations
  static const _logoDuration = Duration(milliseconds: 1000);
  static const _textDuration = Duration(milliseconds: 800);
  static const _shaderDuration = Duration(milliseconds: 1000);
  static const _navigationDelay = Duration(milliseconds: 2500);

  late AnimationController _logoController;
  late AnimationController _textController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _scheduleNavigation();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(vsync: this, duration: _logoDuration);
    _textController = AnimationController(vsync: this, duration: _textDuration);

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), _textController.forward);
  }

  void _scheduleNavigation() {
    final router = context.router;
    Future.delayed(_navigationDelay, () {
      router.replace(const HomeTabRouter());
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GradientScaffold(
        body: Stack(
          children: [
            _buildContent(),
            _buildShaderMask(),
          ],
        ),
      );

  Widget _buildContent() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AnimatedLogo(controller: _logoController),
            const SizedBox(height: (kPadding * 4)),
            _AnimatedText(controller: _textController),
          ],
        ),
      );

  Widget _buildShaderMask() => Positioned.fill(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: _shaderDuration,
          builder: (context, value, child) => ShaderMask(
            shaderCallback: (rect) => _createGradientShader(rect, value),
            blendMode: BlendMode.dstIn,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
            ),
          ),
        ),
      );

  Shader _createGradientShader(Rect rect, double value) {
    final theme = Theme.of(context);
    return RadialGradient(
      center: Alignment.center,
      radius: value * 5,
      colors: [
        theme.scaffoldBackgroundColor,
        theme.scaffoldBackgroundColor.withOpacity(0.0),
      ],
      stops: const [0.0, 1.0],
    ).createShader(rect);
  }
}

class _AnimatedLogo extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedLogo({required this.controller});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Transform.scale(
          scale: Tween<double>(begin: 0.5, end: 1.0)
              .animate(
                  CurvedAnimation(parent: controller, curve: Curves.elasticOut))
              .value,
          child: Opacity(
            opacity: Tween<double>(begin: 0.0, end: 1.0)
                .animate(
                    CurvedAnimation(parent: controller, curve: Curves.easeIn))
                .value,
            child: const AppLogo(
              width: 134,
              height: 128,
            ),
          ),
        ),
      );
}

class _AnimatedText extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedText({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: controller,
        child: Column(
          children: [
            Text(
              'Odoo',
              style: textTheme.headlineLarge,
            ),
            const SizedBox(height: kPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding * 2),
              child: Text(
                'Time management without obstacles',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

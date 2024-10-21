import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/utils/utils.dart';

class SyncAnimation extends StatelessWidget {
  const SyncAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    const animationSize = kPadding * 5;
    final textStyle = AppTextStyle.titleMedium.copyWith(
      color: Colors.white,
    );

    final List<String> syncMessages = [
      'Syncing data...',
      'Almost there...',
      'Preparing your content...',
      'Fetching latest updates...',
      'Syncing with the server...',
      'This won\'t take long...',
      'We are finalizing your data...'
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: animationSize + 20,
                height: animationSize + 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.blueAccent, Colors.transparent],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                ),
              ),
              Lottie.asset(
                Assets.animationSyncing,
                height: animationSize,
                width: animationSize,
                repeat: true,
              ),
            ],
          ),
          const SizedBox(
              height: 20), // Add spacing between the animation and text
          SizedBox(
            height: 50,
            child: AnimatedTextKit(
              animatedTexts: syncMessages
                  .map(
                    (e) => FadeAnimatedText(e, textStyle: textStyle),
                  )
                  .toList(),
              repeatForever: true,
              pause: const Duration(
                  milliseconds: 500), // Pause between text changes
              onTap: () {
                // Optionally, handle tap events here
              },
            ),
          ),
        ],
      ),
    );
  }
}

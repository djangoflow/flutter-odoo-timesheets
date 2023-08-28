import 'package:flutter/material.dart';
import 'package:timesheets/utils/assets.gen.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) => Assets.appLogoLogoSvg.svg(
        height: height,
        width: width,
      );
}

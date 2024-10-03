import 'package:flutter/material.dart';
import 'package:timesheets/utils/assets.gen.dart';

import 'decorated_svg_image.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) => DecoratedSvgImage(
        image: Assets.appLogoLogoSvg,
        height: height,
        width: width,
      );
}

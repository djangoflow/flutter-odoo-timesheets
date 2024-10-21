import 'package:flutter/material.dart';

import 'package:timesheets/configurations/theme/theme.dart';
import 'package:timesheets/utils/assets.gen.dart';

class DecoratedSvgImage extends StatelessWidget {
  const DecoratedSvgImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.decorationHeight,
    this.decorationWidth,
    this.padding,
  });
  final SvgGenImage image;
  final double? height;
  final double? width;
  final double? decorationHeight;
  final double? decorationWidth;
  final double? padding;

  @override
  Widget build(BuildContext context) => Container(
        height: decorationHeight ?? 192,
        width: decorationWidth ?? 192,
        decoration: BoxDecoration(
          color: AppColors.getTintedSurfaceColor(
            Theme.of(context).colorScheme.surfaceTint,
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        padding: EdgeInsets.all(padding ?? 24),
        child: Center(
          child: image.svg(
            height: height,
            width: width,
          ),
        ),
      );
}

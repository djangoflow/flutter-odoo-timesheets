import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  });
  final SvgGenImage image;
  final double? height;
  final double? width;
  final double? decorationHeight;
  final double? decorationWidth;

  @override
  Widget build(BuildContext context) => Container(
        height: decorationHeight ?? 192.h,
        width: decorationWidth ?? 192.h,
        decoration: BoxDecoration(
          color: AppColors.getTintedSurfaceColor(
            Theme.of(context).colorScheme.surfaceTint,
          ),
          borderRadius: BorderRadius.circular(32.r),
        ),
        padding: EdgeInsets.all(24.w),
        child: image.svg(
          height: height,
          width: width,
        ),
      );
}

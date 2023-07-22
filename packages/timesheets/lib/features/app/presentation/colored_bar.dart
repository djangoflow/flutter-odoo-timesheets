import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';

class ColoredBar extends StatelessWidget {
  const ColoredBar({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => VerticalDivider(
        color: color,
        thickness: kPadding.w / 4,
        width: kPadding.w / 4,
        endIndent: 0,
        indent: 0,
      );
}

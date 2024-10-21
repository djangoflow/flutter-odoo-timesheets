import 'package:flutter/material.dart';

import 'package:timesheets/configurations/configurations.dart';

class ColoredBar extends StatelessWidget {
  const ColoredBar({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => VerticalDivider(
        color: color,
        thickness: kPadding / 4,
        width: kPadding / 4,
        endIndent: 0,
        indent: 0,
      );
}

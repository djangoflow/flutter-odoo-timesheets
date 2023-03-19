import 'package:flutter/material.dart';

import 'package:timesheets/configurations/constants.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
        appLogoPngPath,
        height: size,
        width: size,
      );
}

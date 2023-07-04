import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:timesheets/configurations/constants.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        context.read<AppCubit>().state.themeMode == ThemeMode.light
            ? appLogoDarkPath
            : appLogoPath,
        height: size,
        width: size,
      );
}

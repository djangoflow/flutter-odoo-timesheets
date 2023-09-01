import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class OdooProjectsPlaceHolder extends EmptyPlaceholder {
  OdooProjectsPlaceHolder(
      {super.key, super.onGetStarted, super.buttonText, required super.message})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsOdooLogo,
            // height: 92.h,
            width: 150.h,
          ),
          title: 'You don\'t have any projects from odoo',
        );
}

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class OdooTimesheetsPlaceHolder extends EmptyPlaceholder {
  OdooTimesheetsPlaceHolder(
      {super.key, super.onGetStarted, required super.message})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsOdooLogo,
            // height: 92.h,
            width: 150.h,
          ),
          title: 'You don\'t have any Odoo timesheets',
        );
}

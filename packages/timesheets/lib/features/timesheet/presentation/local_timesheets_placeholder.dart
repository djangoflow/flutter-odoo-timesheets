import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class LocalTimesheetsPlaceHolder extends EmptyPlaceholder {
  LocalTimesheetsPlaceHolder({super.key, super.onGetStarted})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsClock,
            height: 92.h,
            width: 92.h,
          ),
          title: 'You don\'t have any local timesheets',
          message: 'Create a timer to to begin tracking time',
        );
}

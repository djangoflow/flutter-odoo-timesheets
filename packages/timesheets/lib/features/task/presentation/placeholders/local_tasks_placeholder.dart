import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class LocalTasksPlaceHolder extends EmptyPlaceholder {
  LocalTasksPlaceHolder({super.key, super.onGetStarted})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsClock,
            height: 96.h,
            width: 96.h,
          ),
          title: 'You don\'t have any local timesheets in this project',
          message: 'Create a timer to to begin tracking time',
          height: .85,
        );
}

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class EmptyTasksPlaceHolder extends EmptyPlaceholder {
  EmptyTasksPlaceHolder({super.key, super.onGetStarted, String? title})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsClock,
            height: 96.h,
            width: 96.h,
          ),
          title: title ?? 'You don\'t have any tasks in this project',
          message: 'Create a timer to to begin tracking time',
          height: .85,
        );
}

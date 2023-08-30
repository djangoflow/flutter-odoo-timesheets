import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class LocalProjectsPlaceHolder extends EmptyPlaceholder {
  LocalProjectsPlaceHolder({super.key, super.onGetStarted})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsWork,
            height: 96.h,
            width: 96.h,
          ),
          title: 'You don\'t have any local projects',
          message: 'Create a project to begin',
        );
}

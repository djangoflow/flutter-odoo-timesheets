import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class EmptyProjectsPlaceholder extends EmptyPlaceholder {
  EmptyProjectsPlaceholder({super.key, super.onGetStarted, String? title})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsWork,
            height: 96.h,
            width: 96.h,
          ),
          title: title ?? 'You don\'t have any projects',
          message: 'Create a project to begin',
        );
}

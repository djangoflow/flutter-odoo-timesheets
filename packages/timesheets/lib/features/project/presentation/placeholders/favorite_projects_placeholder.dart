import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class FavoriteProjectsPlaceHolder extends EmptyPlaceholder {
  FavoriteProjectsPlaceHolder({super.key, super.onGetStarted})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsFavorite,
            height: 96.h,
            width: 96.h,
          ),
          title: 'No favorite projects yet',
          message:
              'You can mark a project as favorite either on the timer creation page or within an existing project',
        );
}

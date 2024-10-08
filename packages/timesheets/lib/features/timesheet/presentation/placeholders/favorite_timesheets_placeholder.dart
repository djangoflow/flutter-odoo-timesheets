import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class FavoriteTimesheetsPlaceHolder extends EmptyPlaceholder {
  FavoriteTimesheetsPlaceHolder({super.key, super.onGetStarted})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsFavorite,
            height: 96.h,
            width: 96.h,
          ),
          title: 'No favorited timesheets yet',
          message:
              'You can mark a timer as favorite either on the timer creation page or within an existing timesheet',
        );
}

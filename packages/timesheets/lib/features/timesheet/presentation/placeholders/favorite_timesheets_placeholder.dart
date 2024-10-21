import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class FavoriteTimesheetsPlaceHolder extends EmptyPlaceholder {
  const FavoriteTimesheetsPlaceHolder({super.key, super.onGetStarted})
      : super(
          icon: const DecoratedSvgImage(
            image: Assets.iconsFavorite,
            height: 96,
            width: 96,
          ),
          title: 'No favorited timesheets yet',
          message:
              'You can mark a timer as favorite either on the timer creation page or within an existing timesheet',
        );
}

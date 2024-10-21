import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class TimesheetsPlaceHolder extends EmptyPlaceholder {
  TimesheetsPlaceHolder({super.key, super.onGetStarted})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsClock,
            height: 96,
            width: 96,
          ),
          title: 'You don\'t have any timer created',
          message: 'Create a timer to to begin tracking time',
        );
}

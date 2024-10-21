import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class EmptyTasksPlaceHolder extends EmptyPlaceholder {
  const EmptyTasksPlaceHolder({super.key, super.onGetStarted, String? title})
      : super(
          icon: const DecoratedSvgImage(
            image: Assets.iconsClock,
            height: 96,
            width: 96,
          ),
          title: title ?? 'You don\'t have any tasks in this project',
          message: 'Create a timer to to begin tracking time',
          heightFactor: .85,
        );
}

import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class FavoriteProjectsPlaceHolder extends EmptyPlaceholder {
  const FavoriteProjectsPlaceHolder({super.key, super.onGetStarted})
      : super(
          icon: const DecoratedSvgImage(
            image: Assets.iconsFavorite,
            height: 96,
            width: 96,
          ),
          title: 'No favorite projects yet',
          message:
              'You can mark a project as favorite either on the timer creation page or within an existing project',
        );
}

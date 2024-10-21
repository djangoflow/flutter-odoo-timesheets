import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class OdooProjectsPlaceHolder extends EmptyPlaceholder {
  OdooProjectsPlaceHolder(
      {super.key, super.onGetStarted, super.buttonText, required super.message})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsOdooLogo,
            // height: 92,
            width: 150,
          ),
          title: 'You don\'t have any projects from odoo',
        );
}

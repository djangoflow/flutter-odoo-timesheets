import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class OdooTimesheetsPlaceHolder extends EmptyPlaceholder {
  const OdooTimesheetsPlaceHolder(
      {super.key, super.onGetStarted, required super.message})
      : super(
          icon: const DecoratedSvgImage(
            image: Assets.iconsOdooLogo,
            // height: 92,
            width: 150,
          ),
          title: 'You don\'t have any Odoo timesheets',
        );
}

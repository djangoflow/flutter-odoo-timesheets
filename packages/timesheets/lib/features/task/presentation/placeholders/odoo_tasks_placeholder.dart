import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class OdooTasksPlaceHolder extends EmptyPlaceholder {
  OdooTasksPlaceHolder({super.key, super.onGetStarted})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsOdooLogo,
            // height: 92.h,
            width: 150.h,
          ),
          title: 'You don\'t have any odoo timesheets',
          message:
              'Create tasks in odoo and re-synchronize the app to get started',
          buttonText: 'Re-syncronize tasks with odoo',
          height: .85,
        );
}

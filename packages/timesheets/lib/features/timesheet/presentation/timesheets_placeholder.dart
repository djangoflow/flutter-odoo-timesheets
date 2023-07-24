import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

import 'timesheet_list_tile.dart';

class TimesheetsPlaceHolder extends StatelessWidget {
  const TimesheetsPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: .7.sh,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kPadding.h * 2,
          ),
          const Text(
              'You don\'t have any timers at the moment. Create a timesheet to begin.'),
          SizedBox(
            height: kPadding.h * 2,
          ),
          Stack(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => TimesheetListTile.placeholder(
                  key: ValueKey(index),
                ),
                separatorBuilder: (context, index) => SizedBox(
                  height: kPadding.h,
                ),
                itemCount: 3,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.1, 1],
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.surface,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.router.push(
                  TimesheetRouter(
                    children: [
                      TimesheetAddRoute(),
                    ],
                  ),
                );
              },
              child: const Text('Create a Timesheet'),
            ),
          ),
        ],
      ),
    );
  }
}

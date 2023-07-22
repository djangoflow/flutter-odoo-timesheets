import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

import 'task_list_tile.dart';

class TasksPlaceHolder extends StatelessWidget {
  const TasksPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.all(kPadding.w * 2),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You don\'t have any tasks yet',
                  style: textTheme.titleMedium,
                ),
                SizedBox(
                  height: kPadding.h * 2,
                ),
                Card(
                  elevation: 6,
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        context.router.push(
                          TasksRouter(
                            children: [
                              TimesheetAddRoute(),
                            ],
                          ),
                        );
                      },
                      child: const Text('Add new task'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: kPadding.h * 2,
        ),
        Stack(
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => TaskListTile.placeholder(
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
                      theme.colorScheme.onPrimary,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

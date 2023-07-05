import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';

class TasksPlaceHolder extends StatelessWidget {
  const TasksPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
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
                  onPressed: () {},
                  child: const Text('Add new task'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

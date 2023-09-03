import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetListTile extends StatelessWidget {
  const TimesheetListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.disabled = false,
    this.onTap,
    this.elapsedTime,
    this.initialTimerStatus,
    this.onTimerStateChange,
    this.onTimerResume,
    this.leadingBarColor,
  });
  final Widget title;
  final Widget subtitle;
  final bool disabled;

  /// In seconds
  final int? elapsedTime;
  final TimesheetStatusEnum? initialTimerStatus;
  final VoidCallback? onTap;
  final Color? leadingBarColor;
  final void Function(
          BuildContext context, TimerState timerState, int tickInterval)?
      onTimerStateChange;
  final void Function(BuildContext context)? onTimerResume;

  factory TimesheetListTile.placeholder({
    Key? key,
  }) =>
      TimesheetListTile(
        key: key,
        title: Builder(
          builder: (context) => _PlaceholderContainer(
            height: kPadding.h * 3.5,
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withOpacity(.16),
          ),
        ),
        subtitle: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.only(top: kPadding.h / 2),
            child: _PlaceholderContainer(
              height: kPadding.h * 2,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withOpacity(.08),
            ),
          ),
        ),
        disabled: true,
      );

  @override
  Widget build(BuildContext context) => ListTile(
        leading: leadingBarColor != null
            ? SizedBox(
                height: double.infinity,
                child: ColoredBar(
                  color: leadingBarColor!,
                ),
              )
            : null,
        title: title,
        horizontalTitleGap: 0,
        subtitle: subtitle,
        trailing: TaskTimer.small(
          disabled: disabled,
          onTimerStateChange: onTimerStateChange,
          elapsedTime: elapsedTime,
          initialTimerStatus: initialTimerStatus,
          onTimerResume: onTimerResume,
        ),
        onTap: onTap,
      );
}

class _PlaceholderContainer extends StatelessWidget {
  const _PlaceholderContainer({required this.color, required this.height});
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: color,
        ),
      );
}

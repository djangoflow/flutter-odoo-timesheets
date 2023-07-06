import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.disabled = false,
    this.onTap,
    this.elapsedTime,
    this.initialTimerStatus,
    this.onTimerStateChange,
    this.onTimerResume,
  });
  final Widget title;
  final Widget subtitle;
  final bool disabled;

  /// In seconds
  final int? elapsedTime;
  final TimerStatus? initialTimerStatus;
  final VoidCallback? onTap;
  final void Function(TimerState, int)? onTimerStateChange;
  final void Function(BuildContext context)? onTimerResume;

  factory TaskListTile.placeholder({
    Key? key,
  }) =>
      TaskListTile(
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
  Widget build(BuildContext context) => Stack(
        children: [
          ListTile(
            title: title,
            subtitle: subtitle,
            trailing: TaskTimer.small(
              disabled: disabled,
              onTimerStateChange: onTimerStateChange,
              elapsedTime: elapsedTime,
              initialTimerStatus: initialTimerStatus,
              onTimerResume: onTimerResume,
            ),
            onTap: onTap,
          ),
          if (disabled)
            Positioned.fill(
              child: Container(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.5),
              ),
            ),
        ],
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

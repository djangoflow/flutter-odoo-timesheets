import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

class TimerSmall extends StatelessWidget {
  const TimerSmall(
      {Key? key,
      required this.isActive,
      required this.startTime,
      required this.isPlaceholder})
      : super(key: key);

  final bool isActive;
  final DateTime startTime;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: isActive ? theme.colorScheme.primary : theme.colorScheme.surface,
      elevation: kPadding / 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            kPadding * 8,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          kPadding * 2,
        ),
        child: Row(
          children: [
            Text(
              _format(
                duration: DateTime.now().difference(startTime),
              ),
              style: theme.textTheme.titleSmall?.copyWith(
                color: isActive
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(
              width: kPadding,
            ),
            if (isActive)
              GestureDetector(
                onTap: () {},
                child: Icon(
                  CupertinoIcons.pause,
                  size: kPadding * 3,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            else
              GestureDetector(
                onTap: () {},
                child: Icon(
                  CupertinoIcons.play_arrow_solid,
                  size: kPadding * 3,
                  color: theme.colorScheme.onSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }

  _format({required Duration duration}) =>
      duration.toString().split('.').first.padLeft(8, '0').substring(0, 5);
}

import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

class ActivityTitle extends StatelessWidget {
  const ActivityTitle({
    super.key,
    required this.iconData,
    required this.title,
    this.rowAlignment = MainAxisAlignment.start,
  });

  final IconData iconData;
  final String title;
  final MainAxisAlignment rowAlignment;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding * 2.5),
      child: Row(
        mainAxisAlignment: rowAlignment,
        children: [
          Icon(
            iconData,
            size: kPadding * 4,
          ),
          const SizedBox(
            width: kPadding * 2,
          ),
          Flexible(
            child: Text(
              title,
              style: textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}

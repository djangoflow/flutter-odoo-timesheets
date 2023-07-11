import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

class SettingsListItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget? leading;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double horizontalTitleGap;

  const SettingsListItem({
    Key? key,
    required this.title,
    this.leading,
    this.onTap,
    this.trailing,
    this.horizontalTitleGap = kPadding,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: kPadding / 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kPadding),
      ),
      color: theme.colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kPadding * 2,
          vertical: kPadding,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: subTitle != null
            ? Text(
                subTitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        horizontalTitleGap: horizontalTitleGap,
        trailing: trailing,
        leading: leading,
        onTap: onTap,
      ),
    );
  }
}

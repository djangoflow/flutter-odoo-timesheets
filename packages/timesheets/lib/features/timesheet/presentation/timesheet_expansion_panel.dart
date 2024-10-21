import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rich_readmore/rich_readmore.dart';
import 'package:timesheets/configurations/configurations.dart';

import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetExpansionTile extends StatelessWidget {
  final TimesheetModel timesheet;
  final void Function(bool)? onExpansionChanged;
  final bool initiallyExpanded;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;
  final Function(BuildContext context)? onEdit;
  const TimesheetExpansionTile({
    super.key,
    required this.timesheet,
    this.onExpansionChanged,
    this.initiallyExpanded = false,
    this.leading,
    this.trailing,
    this.subtitle,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          listTileTheme: Theme.of(context).listTileTheme.copyWith(
                tileColor: Colors.transparent,
              ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: ExpansionTile(
            title: _TimesheetExpansionHeader(timesheet: timesheet),
            subtitle: subtitle,
            onExpansionChanged: onExpansionChanged,
            trailing: trailing ?? const SizedBox(),
            leading: leading,
            controlAffinity: ListTileControlAffinity.trailing,
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            initiallyExpanded: initiallyExpanded,
            children: [
              Divider(
                endIndent: kPadding * 2,
                indent: kPadding * 2,
                height: kPadding,
              ),
              _TimesheetDescription(
                description: timesheet.name,
                id: timesheet.id,
                onEdit: onEdit,
              ),
            ],
          ),
        ),
      );
}

class TimesheetExpansionPanel extends ExpansionPanel {
  TimesheetExpansionPanel({
    required this.timesheet,
    super.isExpanded,
    super.backgroundColor,
    super.canTapOnHeader,
  }) : super(
          headerBuilder: (context, isExpanded) => _TimesheetExpansionHeader(
            timesheet: timesheet,
          ),
          body: const Text('Expanded'),
        );
  final TimesheetModel timesheet;
}

class _TimesheetExpansionHeader extends StatelessWidget {
  const _TimesheetExpansionHeader({required this.timesheet});
  final TimesheetModel timesheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          timesheet.createDate.toDayString(),
          style: textTheme.bodySmall,
        ),
        SizedBox(
          height: kPadding / 2,
        ),
        Text(
          timesheet.createDate.toDateString(delimeter: '.'),
          style: textTheme.titleMedium,
        ),
        SizedBox(
          height: kPadding / 2,
        ),
        Text(
          'Start Time ${timesheet.createDate.toTimeString()}',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _TimesheetDescription extends StatelessWidget {
  const _TimesheetDescription(
      {this.description, required this.id, required this.onEdit});
  final String? description;
  final int id;
  final Function(BuildContext context)? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(kPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Description',
                  style: textTheme.bodySmall,
                ),
                if (onEdit != null) ...[
                  const Spacer(),
                  IconButton(
                    style: theme.iconButtonTheme.style?.copyWith(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      maximumSize: WidgetStatePropertyAll(
                        Size(kPadding * 4, kPadding * 4),
                      ),
                      minimumSize: WidgetStatePropertyAll(
                        Size(kPadding * 4, kPadding * 4),
                      ),
                      alignment: Alignment.center,
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.zero,
                      ),
                      iconSize: WidgetStatePropertyAll(kPadding * 2.5),
                    ),
                    onPressed: () => onEdit!(context),
                    icon: const Icon(CupertinoIcons.pencil),
                  ),
                ],
              ],
            ),
            SizedBox(
              height: kPadding / 2,
            ),
            RichReadMoreText(
              TextSpan(text: description ?? ''),
              settings: LineModeSettings(
                trimLines: 2,
                moreStyle: textTheme.bodySmall,
                lessStyle: textTheme.bodySmall,
                trimExpandedText: '\nRead less',
                trimCollapsedText: '...\nRead more',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

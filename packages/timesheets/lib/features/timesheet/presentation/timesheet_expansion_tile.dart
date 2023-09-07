import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rich_readmore/rich_readmore.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetExpansionTile extends StatelessWidget {
  final Timesheet timesheet;
  final void Function(bool)? onExpansionChanged;
  final bool initiallyExpanded;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;
  const TimesheetExpansionTile({
    super.key,
    required this.timesheet,
    this.onExpansionChanged,
    this.initiallyExpanded = false,
    this.leading,
    this.trailing,
    this.subtitle,
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
                endIndent: kPadding.w * 2,
                indent: kPadding.w * 2,
                height: kPadding.h,
              ),
              _TimesheetDescription(
                description: timesheet.description,
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
  final Timesheet timesheet;
}

class _TimesheetExpansionHeader extends StatelessWidget {
  const _TimesheetExpansionHeader({required this.timesheet});
  final Timesheet timesheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (timesheet.startTime != null) ...[
          Text(
            timesheet.startTime!.toDayString(),
            style: textTheme.bodySmall,
          ),
          SizedBox(
            height: kPadding.h / 2,
          ),
          Text(
            timesheet.startTime!.toDateString(delimeter: '.'),
            style: textTheme.titleMedium,
          ),
          SizedBox(
            height: kPadding.h / 2,
          ),
          Text(
            'Start Time ${timesheet.startTime!.toTimeString()}',
            style: textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _TimesheetDescription extends StatelessWidget {
  const _TimesheetDescription({this.description});
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(kPadding.h * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Description',
                  style: textTheme.bodySmall,
                ),
                const Spacer(),
                IconButton(
                  style: theme.iconButtonTheme.style?.copyWith(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    maximumSize: MaterialStatePropertyAll(
                      Size(kPadding.h * 4, kPadding.h * 4),
                    ),
                    minimumSize: MaterialStatePropertyAll(
                      Size(kPadding.h * 4, kPadding.h * 4),
                    ),
                    alignment: Alignment.center,
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.zero,
                    ),
                    iconSize: MaterialStatePropertyAll(kPadding.h * 2.5),
                  ),
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.pencil),
                ),
              ],
            ),
            SizedBox(
              height: kPadding.h / 2,
            ),
            RichReadMoreText(
              TextSpan(text: description ?? ''),
              settings: LineModeSettings(
                trimLines: 2,
                textAlign: TextAlign.end,
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

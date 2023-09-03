import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

class OptionSelector extends StatelessWidget {
  const OptionSelector({super.key, required this.options});

  final List<Options> options;

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kPadding.h * 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding.w * 2),
              child: Text(
                'Select an option',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                left: kPadding.w * 2,
                right: kPadding.w * 2,
                top: kPadding.h * 2,
              ),
              itemCount: options.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final option = options[index];

                return InkWell(
                  onTap: () => context.router.pop(option),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: kPadding.h,
                    ),
                    child: Row(
                      children: [
                        Icon(option.icon),
                        SizedBox(
                          width: kPadding.w,
                        ),
                        Text(option.label),
                      ],
                    ),
                  ),
                );
              },
            ),
            Divider(
              endIndent: kPadding.w * 2,
              indent: kPadding.w * 2,
            ),
          ],
        ),
      );
}

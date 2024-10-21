import 'package:flutter/material.dart';

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
            const SizedBox(
              height: kPadding * 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding * 2),
              child: Text(
                'Select an option',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: kPadding * 2,
                right: kPadding * 2,
                top: kPadding * 2,
              ),
              itemCount: options.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final option = options[index];

                return InkWell(
                  onTap: () => context.router.maybePop(option),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: kPadding,
                    ),
                    child: Row(
                      children: [
                        Icon(option.icon),
                        const SizedBox(
                          width: kPadding,
                        ),
                        Text(option.label),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(
              endIndent: kPadding * 2,
              indent: kPadding * 2,
            ),
          ],
        ),
      );
}

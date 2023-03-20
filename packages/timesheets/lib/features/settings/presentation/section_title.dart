import 'package:flutter/material.dart';

import '../../../configurations/configurations.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;

  const SectionTitle({Key? key, required this.title, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ??
            const EdgeInsets.only(
              bottom: kPadding,
            ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
}

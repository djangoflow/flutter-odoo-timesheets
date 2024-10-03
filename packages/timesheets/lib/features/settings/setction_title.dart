import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;

  const SectionTitle({super.key, required this.title, this.padding});

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ??
            EdgeInsets.only(
              bottom: kPadding.h,
            ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
}

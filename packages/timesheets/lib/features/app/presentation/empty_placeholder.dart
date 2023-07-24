import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: .7.sh,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kPadding.h * 2,
          ),
          Text(message),
          SizedBox(
            height: kPadding.h * 2,
          ),
          Stack(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTileSkeleton(
                  effect: SoldColorEffect(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.24),
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(
                  height: kPadding.h,
                ),
                itemCount: 3,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.1, 1],
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.surface,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

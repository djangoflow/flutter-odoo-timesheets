import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/timer/timer.dart';

import '../../../../configurations/configurations.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({
    super.key,
  });

  final double iconSize = 35;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ActivityState activityState = context.watch<ActivityCubit>().state;
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocListener<ActivityCubit, ActivityState>(
      listener: (context, state) {
        if (state.activityStatus == ActivityStatus.syncing) {
          context.router.navigateBack();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activity Detail'),
        ),
        body: SizedBox(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: kPadding * 4,
              ),
              Text(
                activityState.description ?? '',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(
                height: kPadding * 4,
              ),
              getSingleDetail(activityState.project?.name ?? '',
                  Icons.work_history_outlined, textTheme),
              const SizedBox(
                height: kPadding * 4,
              ),
              getSingleDetail(activityState.task?.name ?? '',
                  Icons.extension_outlined, textTheme),
              const SizedBox(
                height: kPadding * 8,
              ),
              Text(
                'Total worked today',
                style: textTheme.labelLarge,
              ),
              const TimerWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSingleDetail(
    String title,
    IconData iconData,
    TextTheme textTheme,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding * 2.5),
        child: Row(
          children: [
            Icon(
              iconData,
              size: iconSize,
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

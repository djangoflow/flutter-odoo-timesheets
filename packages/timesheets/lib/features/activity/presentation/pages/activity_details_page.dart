import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/timer/timer.dart';

import '../../../../configurations/configurations.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final activityState = context.watch<ActivityCubit>().state;
    final textTheme = Theme.of(context).textTheme;

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
              Text(
                activityState.description ?? '',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(
                height: kPadding * 4,
              ),
              ActivityTitle(
                iconData: Icons.work_history_outlined,
                title: activityState.project?.name ?? '',
              ),
              const SizedBox(
                height: kPadding * 4,
              ),
              ActivityTitle(
                iconData: Icons.extension_outlined,
                title: activityState.task?.name ?? '',
              ),
              const SizedBox(
                height: kPadding * 8,
              ),
              Text(
                'Total worked today',
                style: textTheme.labelLarge,
              ),
              const LargeTimerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

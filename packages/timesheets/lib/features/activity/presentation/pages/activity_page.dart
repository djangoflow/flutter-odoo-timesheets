import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/activity.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activityStatus = context.watch<ActivityCubit>().state.activityStatus;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(kPadding * 2),
          child: Text(
            _getAppBarTitle(
              activityStatus,
            ),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        centerTitle: activityStatus == ActivityStatus.initial,
        actions: activityStatus != ActivityStatus.initial ? [
          IconButton(
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kPadding),
              ),
            ),
            icon: const Icon(
              Icons.settings_outlined,
            ),
            onPressed: () {},
          ),
          IconButton(
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kPadding),
              ),
            ),
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ] : null,
      ),
      body: SingleChildScrollView(
        child: getChild(
          activityStatus,
        ),
      ),
    );
  }

  Widget getChild(ActivityStatus status) {
    if (status == ActivityStatus.initial) {
      return const ActivityStart();
    } else if (status == ActivityStatus.ongoing) {
      return const ActivityOngoing();
    } else {
      return const ActivitySyncing();
    }
  }

  String _getAppBarTitle(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.initial:
        return 'Add Task';
      default:
        return 'Tasks';
    }
  }
}

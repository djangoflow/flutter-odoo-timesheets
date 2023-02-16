import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/project/project.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final user = context.read<AuthCubit>().state.user;
      if (user != null) {
        context.read<ProjectCubit>().loadProjects(user.id, user.pass);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Log work'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(kPadding * 2),
          child: SingleChildScrollView(
            child: BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, state) {
                if (state.activityStatus == ActivityStatus.initial) {
                  return const ActivityStart();
                } else if (state.activityStatus == ActivityStatus.ongoing) {
                  return const ActivityOngoing();
                } else {
                  return const ActivitySyncing();
                }
              },
            ),
          ),
        ),
      );
}

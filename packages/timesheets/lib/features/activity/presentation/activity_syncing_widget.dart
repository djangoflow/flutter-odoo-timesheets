import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/blocs/activity_cubit.dart';

class ActivitySyncing extends StatelessWidget {
  const ActivitySyncing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(kPadding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: kPadding * 2),
              Text(
                'Syncing Activity. Please wait...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
}

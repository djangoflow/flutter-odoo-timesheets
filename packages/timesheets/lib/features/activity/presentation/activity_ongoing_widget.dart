import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/blocs/activity_cubit.dart';
import 'package:timesheets/features/activity/presentation/activity_title_widget.dart';
import 'package:timesheets/features/timer/presentation/timer_large.dart';

class ActivityOngoing extends StatelessWidget {
  const ActivityOngoing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          // context.navigateTo(const ActivityDetailsRoute());
        },
        child: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) => Card(
            // color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(kPadding * 2),
              child: Column(
                children: [
                  const SizedBox(height: kPadding * 2),
                  ActivityTitle(
                    rowAlignment: MainAxisAlignment.center,
                    iconData: Icons.wb_incandescent_outlined,
                    title: state.description ?? '',
                  ),
                  const LargeTimerWidget(),
                ],
              ),
            ),
          ),
        ),
      );
}

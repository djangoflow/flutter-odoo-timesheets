import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/blocs/activity_cubit.dart';
import 'package:timesheets/features/timer/presentation/timer_widget.dart';

class ActivityOngoing extends StatelessWidget {
  const ActivityOngoing({Key? key}) : super(key: key);

  final double iconSize = 35;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          context.navigateTo(const ActivityDetailsRoute());
        },
        child: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) => Card(
            // color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(kPadding * 2),
              child: Column(
                children: [
                  const SizedBox(height: kPadding * 2),
                  getSingleDetail('${state.description}',
                      Icons.wb_incandescent_outlined, context),
                  const TimerWidget(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget getSingleDetail(
          String title, IconData iconData, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding * 2.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      );
}

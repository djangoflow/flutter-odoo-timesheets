import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/tasks/presentation/task_card.dart';

class EmptyTaskListPage extends StatelessWidget {
  const EmptyTaskListPage({
    super.key,
    this.emptyTasksCount = 3,
  });

  final int emptyTasksCount;

  @override
  Widget build(BuildContext context) {
    final schemeColors = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Card(
            color: schemeColors.primaryContainer,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(kPadding * 2),
              child: Column(
                children: [
                  Text(
                    'You don\'t have any tasks yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: schemeColors.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(
                    height: kPadding * 2,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: schemeColors.surface,
                        elevation: kPadding * 3/8,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Add new task',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: kPadding,
        ),
        Stack(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => TaskCard.placeholder(),
              itemCount: emptyTasksCount,
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.8, 1],
                    colors: [
                      if (AppCubit.instance.state.themeMode == ThemeMode.light)
                        Colors.white.withOpacity(0.2)
                      else
                        Colors.transparent,
                      if (AppCubit.instance.state.themeMode == ThemeMode.light)
                        Colors.white
                      else
                        Colors.black,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

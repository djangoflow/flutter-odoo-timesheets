import 'package:flutter/material.dart';
import 'package:timesheets/features/tasks/data/models/active_task_model.dart';
import 'package:timesheets/features/timer/presentation/timer_small.dart';

import '../../../configurations/theme/size_constants.dart';

abstract class _TaskCardAbstract extends StatelessWidget {
  final Widget taskCardWidget;

  const _TaskCardAbstract({required this.taskCardWidget, super.key});

  @override
  Widget build(BuildContext context) => taskCardWidget;
}

class TaskCard extends _TaskCardAbstract {
  TaskCard({
    required ActiveTask activeTask,
    VoidCallback? onTap,
    super.key,
  }) : super(
          taskCardWidget: Builder(builder: (context) {
            final theme = Theme.of(context);
            return GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.only(top: kPadding),
                child: Card(
                  color: theme.colorScheme.primaryContainer,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(kPadding * 2),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeTask.taskName,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: kPadding / 2),
                            Text(
                              activeTask.projectName,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        TimerSmall(
                          isActive: false,
                          startTime: DateTime.now(),
                          isPlaceholder: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );

  TaskCard.placeholder({
    super.key,
  }) : super(
          taskCardWidget: Builder(
            builder: (context) => Container(
              margin: const EdgeInsets.only(top: kPadding),
              child: Card(
                margin: EdgeInsets.zero,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(kPadding * 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.white.withAlpha((kPadding).toInt()),
                              height: kPadding * 3,
                            ),
                            const SizedBox(height: kPadding / 2),
                            Container(
                              color: Colors.white
                                  .withAlpha((kPadding * 2).toInt()),
                              height: kPadding * 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: kPadding),
                      TimerSmall(
                        isActive: false,
                        startTime: DateTime.now(),
                        isPlaceholder: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
}

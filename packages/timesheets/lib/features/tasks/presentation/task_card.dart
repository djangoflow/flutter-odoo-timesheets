import 'package:flutter/material.dart';
import 'package:timesheets/features/app/presentation/shimmer/app_shimmer.dart';
import 'package:timesheets/features/tasks/data/models/active_task_model.dart';

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
              child: Container(
                margin: const EdgeInsets.only(top: kPadding),
                child: Card(
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
                        //Todo: add timer widget
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
          taskCardWidget: Container(
            margin: const EdgeInsets.only(top: kPadding),
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(kPadding * 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          AppShimmer(
                            child: Container(
                              color: Colors.black.withAlpha(8),
                              height: kPadding * 3,
                            ),
                          ),
                          const SizedBox(height: kPadding / 2),
                          AppShimmer(
                            child: Container(
                              color: Colors.black.withAlpha(8),
                              height: kPadding * 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Todo: add timer widget
                  ],
                ),
              ),
            ),
          ),
        );
}

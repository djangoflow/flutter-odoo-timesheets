import 'package:flutter/material.dart';
import 'package:timesheets/features/tasks/data/models/active_task_model.dart';
import 'package:timesheets/features/tasks/presentation/task_card.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({
    super.key,
    required this.activeTasks,
  });

  final List<ActiveTask> activeTasks;

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) => TaskCard(
          activeTask: activeTasks[index],
        ),
        itemCount: activeTasks.length,
      );
}

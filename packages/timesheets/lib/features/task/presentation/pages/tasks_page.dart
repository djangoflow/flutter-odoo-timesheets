import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: TasksPlaceHolder(),
    );
  }
}

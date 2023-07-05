import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';

@RoutePage()
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                size: kPadding.r * 4,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kPadding.r),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          child: Icon(
            Icons.add,
            size: kPadding.r * 4,
          ),
          onPressed: () async {
            final taskComapnion = TasksCompanion(
              name: const Value('Task'),
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
              description: const Value('Description'),
              duration: const Value(0),
              status: Value(TimerStatus.initial.index),
            );
            final taskId = await context
                .read<AppDatabase>()
                .tasksDao
                .createTask(taskComapnion);
            print(taskId);
            final task =
                await context.read<AppDatabase>().tasksDao.getTaskById(taskId);
            print(task);
          },
        ),
        body: const TasksPlaceHolder(),
      );
}

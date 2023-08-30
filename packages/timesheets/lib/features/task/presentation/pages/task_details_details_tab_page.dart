import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage(
  name: 'TaskDetailsDetailsTab',
)
class TaskDetailsDetailsTabPage extends StatelessWidget {
  const TaskDetailsDetailsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView(
            padding: EdgeInsets.all(kPadding.h * 2),
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.all(kPadding.h * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Description'),
                      Text(state.taskWithProjectExternalData
                              ?.taskWithExternalData.task.description ??
                          ''),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:timesheets/features/task/task.dart';

import '../task_editor.dart';

@RoutePage()
class TaskEditPage extends StatelessWidget {
  const TaskEditPage({super.key, required this.taskWithProjectExternalData});
  // TODO: make it deep linkable
  final TaskWithProjectExternalData taskWithProjectExternalData;

  @override
  Widget build(BuildContext context) {
    final task = taskWithProjectExternalData.task;
    final project = taskWithProjectExternalData.project;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit task'),
        actions: [
          CircularProgressBuilder(
            action: (_) async {
              final router = context.router;
              final projectId = project.id;

              await context
                  .read<TasksRepository>()
                  .deleteTaskByProjectId(projectId);

              DjangoflowAppSnackbar.showInfo('Task deleted');
              router.pop(true);
            },
            builder: (context, action, error) => IconButton(
              onPressed: action,
              icon: const Icon(CupertinoIcons.delete),
            ),
          )
        ],
      ),
      body: TaskEditor(
        taskName: task.name,
        description: task.description,
        projectName: project.name,
        disabled: task.onlineId != null,
        builder: (context, formGroup, formListView) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: formListView,
            ),
            SizedBox(
              width: double.infinity,
              child: SafeArea(
                bottom: true,
                child: LinearProgressBuilder(
                  action: (_) async {
                    final taskName =
                        formGroup.control(taskControlName).value as String;
                    final projectName =
                        formGroup.control(projectControlName).value as String?;
                    final description = formGroup
                        .control(descriptionControlName)
                        .value as String?;

                    await context.read<TasksRepository>().updateTaskWithProject(
                          task: task.copyWith(
                            name: taskName,
                            description: Value(description),
                          ),
                          project: project.copyWith(
                            name: Value(projectName),
                          ),
                        );
                  },
                  onSuccess: () {
                    DjangoflowAppSnackbar.showInfo('Task updated');
                    context.router.pop(true);
                  },
                  builder: (context, action, error) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: kPadding.w),
                    child: ElevatedButton(
                      onPressed: ReactiveForm.of(context)?.valid == true
                          ? action
                          : null,
                      child: const Text('Update task'),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

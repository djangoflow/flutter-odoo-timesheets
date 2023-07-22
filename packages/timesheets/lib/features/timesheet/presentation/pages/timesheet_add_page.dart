import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';

import 'package:timesheets/features/timesheet/presentation/timesheet_with_task_editor.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class TimesheetAddPage extends StatelessWidget {
  const TimesheetAddPage({Key? key, this.taskWithProjectExternalData})
      : super(key: key);
  final TaskWithProjectExternalData? taskWithProjectExternalData;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: Text(
            taskWithProjectExternalData != null
                ? 'Merge with Synced Task'
                : 'Add Timesheet',
          ),
        ),
        body: TimesheetWithTaskEditor(
          displaySycnedItemsOnly:
              taskWithProjectExternalData != null ? true : null,
          builder: (context, form, formListView) => Column(
            children: [
              Expanded(child: formListView),
              SafeArea(
                bottom: true,
                child: ReactiveFormConsumer(
                  builder: (context, form, child) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: kPadding.w * 2),
                    child: LinearProgressBuilder(
                      onSuccess: () async {
                        final router = context.router;
                        DjangoflowAppSnackbar.showInfo(
                            taskWithProjectExternalData != null
                                ? 'Merged successfully'
                                : 'Added successfully');
                        await router.pop(true);
                      },
                      action: (_) => _addOrUpdate(context: context, form: form),
                      builder: (context, action, state) => ElevatedButton(
                        onPressed: form.valid ? action : null,
                        child: Center(
                          child: Text(taskWithProjectExternalData != null
                              ? 'Confirm'
                              : 'Add Timesheet'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _addOrUpdate(
      {required BuildContext context, required FormGroup form}) async {
    final project = form.control(projectControlName).value as Project;
    final task = form.control(taskControlName).value as Task;
    final description = form.control(descriptionControlName).value as String;

    final timesheetRepository = context.read<TimesheetRepository>();
    if (taskWithProjectExternalData != null) {
      // await taskRepository.updateTaskWithProject(
      //   task: taskWithProjectExternalData!.task.copyWith(
      //     name: odooTask.name,
      //     description: Value(description),
      //     onlineId: Value(odooTask.id),
      //   ),
      //   project: taskWithProjectExternalData!.project.copyWith(
      //     name: Value(odooProject.name),
      //     onlineId: Value(odooProject.id),
      //   ),
      // );
      // final updatedTask = await taskRepository
      //     .getTaskById(taskWithProjectExternalData!.task.id);
      // debugPrint('updated task with project ${updatedTask!.toJson()}');
    } else {
      await timesheetRepository.create(
        TimesheetsCompanion(
          projectId: Value(project.id),
          taskId: Value(task.id),
          name: Value(description),
        ),
      );
    }
  }
}

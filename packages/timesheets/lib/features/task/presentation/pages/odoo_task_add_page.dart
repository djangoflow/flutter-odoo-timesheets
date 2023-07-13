import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';
import 'package:timesheets/features/task/presentation/odoo_task_editor.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class OdooTaskAddPage extends StatelessWidget {
  const OdooTaskAddPage({Key? key, this.taskWithProject}) : super(key: key);
  final TaskWithProject? taskWithProject;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(taskWithProject != null
              ? 'Sync with Odoo Task'
              : 'Add Odoo Task'),
        ),
        body: OdooTaskEditor(
          description: taskWithProject?.task.description,
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
                        DjangoflowAppSnackbar.showInfo(taskWithProject != null
                            ? 'Task updated'
                            : 'Task added');
                        await router.pop(true);
                      },
                      action: (_) => _addOrUpdateOdooTimesheet(
                          context: context, form: form),
                      builder: (context, action, state) => ElevatedButton(
                        onPressed: form.valid ? action : null,
                        child: Center(
                          child: Text(
                              taskWithProject != null ? 'Confirm' : 'Add Task'),
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

  Future<void> _addOrUpdateOdooTimesheet(
      {required BuildContext context, required FormGroup form}) async {
    final odooProject = form.control(projectControlName).value as OdooProject;
    final odooTask = form.control(taskControlName).value as OdooTask;
    final description = form.control(descriptionControlName).value as String;

    final taskRepository = context.read<TasksRepository>();
    if (taskWithProject != null) {
      await taskRepository.updateTaskWithProject(
        task: taskWithProject!.task.copyWith(
          name: odooTask.name,
          description: Value(description),
          onlineId: Value(odooTask.id),
        ),
        project: taskWithProject!.project.copyWith(
          name: Value(odooProject.name),
          onlineId: Value(odooProject.id),
        ),
      );
      final updatedTask =
          await taskRepository.getTaskById(taskWithProject!.task.id);
      debugPrint('updated task with project ${updatedTask!.toJson()}');
    } else {
      await taskRepository.createTaskWithProject(
        TasksCompanion(
          name: Value(odooTask.name),
          onlineId: Value(odooTask.id),
          description: Value(description),
        ),
        ProjectsCompanion(
          name: Value(odooProject.name),
          onlineId: Value(odooProject.id),
        ),
      );
    }
  }
}

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/odoo/data/models/odoo_timesheet.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';

import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/task/presentation/odoo_task_editor.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class OdooTaskAddPage extends StatelessWidget {
  const OdooTaskAddPage({Key? key}) : super(key: key);
  // TODO: Pass offline task object optionally if available
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Add Odoo Task'),
        ),
        body: OdooTaskEditor(
          builder: (context, form, formListView) => Column(
            children: [
              Expanded(child: formListView),
              SafeArea(
                bottom: true,
                child: ReactiveFormConsumer(
                  builder: (context, form, child) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: kPadding.w * 2),
                    child: LinearProgressBuilder(
                      action: (_) =>
                          _addOdooTimesheet(context: context, form: form),
                      builder: (context, action, state) => ElevatedButton(
                        onPressed: form.valid ? action : null,
                        child: const Center(
                          child: Text('Add Task'),
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

  Future<void> _addOdooTimesheet(
      {required BuildContext context, required FormGroup form}) async {
    final project = form.control(projectControlName).value as OdooProject;
    final task = form.control(taskControlName).value as OdooTask;
    final description = form.control(descriptionControlName).value as String;

    await context.read<TasksRepository>().createTaskWithProject(
          TasksCompanion(
            name: Value(task.name),
            onlineId: Value(task.id),
            description: Value(description),
          ),
          ProjectsCompanion(
            name: Value(project.name),
            onlineId: Value(project.id),
          ),
        );
    //TODO: or update local task, project with online ids when task was already created before
  }
}

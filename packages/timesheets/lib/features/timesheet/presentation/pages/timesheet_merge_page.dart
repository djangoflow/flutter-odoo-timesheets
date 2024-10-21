import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class TimesheetMergePage extends StatelessWidget {
  const TimesheetMergePage({
    super.key,
    required this.timesheet,
  });

  final TimesheetModel timesheet;

  @override
  Widget build(BuildContext context) => GradientScaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text('Merge with Existing Project'),
        ),
        body: TimesheetWithTaskEditor(
          showOnlySyncedTaskAndProjects: true,
          disableProjectTaskSelection: false,
          description: timesheet.name,
          builder: (context, form, formListView) => Column(
            children: [
              Expanded(child: formListView),
              SafeArea(
                bottom: true,
                child: ReactiveFormConsumer(
                  builder: (context, form, child) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: kPadding * 2),
                    child: LinearProgressBuilder(
                      onSuccess: () async {
                        final router = context.router;
                        DjangoflowAppSnackbar.showInfo('Merged successfully');
                        await router.maybePop(true);
                      },
                      action: (_) =>
                          _mergeTimesheet(context: context, form: form),
                      builder: (context, action, state) => ElevatedButton(
                        onPressed: form.valid ? action : null,
                        child: const Center(
                          child: Text('Confirm'),
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

  Future<void> _mergeTimesheet(
      {required BuildContext context, required FormGroup form}) async {
    final project = (form.control(projectControlName).value as ProjectModel);
    final task = form.control(taskControlName).value as TaskModel;
    final description = form.control(descriptionControlName).value as String;

    final timesheetRepository = context.read<TimesheetRepository>();

    await timesheetRepository.update(
      timesheet.copyWith(
        projectId: project.id,
        taskId: task.id,
        name: description,
      ),
    );
  }
}

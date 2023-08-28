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

@RoutePage()
class TimesheetMergePage extends StatelessWidget {
  const TimesheetMergePage({
    Key? key,
    required this.timesheet,
  }) : super(key: key);

  final Timesheet timesheet;

  @override
  Widget build(BuildContext context) => GradientScaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text('Merge with Synced Project'),
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
                    padding: EdgeInsets.symmetric(horizontal: kPadding.w * 2),
                    child: LinearProgressBuilder(
                      onSuccess: () async {
                        final router = context.router;
                        DjangoflowAppSnackbar.showInfo('Merged successfully');
                        await router.pop(true);
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
    final project = form.control(projectControlName).value as Project;
    final task = form.control(taskControlName).value as Task;
    final description = form.control(descriptionControlName).value as String;

    final timesheetRepository = context.read<TimesheetRepository>();

    await timesheetRepository.update(
      timesheet.copyWith(
        projectId: Value(project.id),
        taskId: Value(task.id),
        name: Value(description),
      ),
    );
  }
}

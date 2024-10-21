import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/timer.dart';

import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class TimesheetAddPage extends StatelessWidget {
  const TimesheetAddPage({
    super.key,
    this.task,
    this.disableProjectTaskSelection,
    this.isInitiallyFavorite,
    this.disableLocalProjectTaskSelection,
    this.project,
  });
  final TaskModel? task;
  final ProjectModel? project;

  final bool? disableLocalProjectTaskSelection;

  /// If true, the project and task selection will be disabled.
  /// Needed when only adding a timesheet for specific Project and Task
  final bool? disableProjectTaskSelection;

  final bool? isInitiallyFavorite;

  @override
  Widget build(BuildContext context) => GradientScaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text(
            'Create Timesheet',
          ),
        ),
        body: TimesheetWithTaskEditor(
          showOnlySyncedTaskAndProjects: disableLocalProjectTaskSelection,
          disableProjectTaskSelection: disableProjectTaskSelection,
          task: task,
          project: project,
          isFavorite: isInitiallyFavorite,
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
                        DjangoflowAppSnackbar.showInfo('Added successfully');
                        await router.maybePop(true);
                      },
                      action: (_) =>
                          _addTimesheet(context: context, form: form),
                      builder: (context, action, state) => ElevatedButton(
                        onPressed: form.valid ? action : null,
                        child: const Center(
                          child: Text(
                            'Create Timesheet',
                          ),
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

  Future<void> _addTimesheet(
      {required BuildContext context, required FormGroup form}) async {
    final project = (form.control(projectControlName).value as ProjectModel);
    final task = form.control(taskControlName).value as TaskModel;
    final description = form.control(descriptionControlName).value as String;
    final isFavorite = form.control(isFavoriteControlName).value as bool;
    final timesheetRepository = context.read<TimesheetRelationalRepository>();

    await timesheetRepository.create(
      TimesheetModel(
        projectId: project.id,
        taskId: task.id,
        name: description,
        createDate: DateTime.timestamp(),
        date: DateTime.timestamp(),
        id: DateTime.timestamp().millisecondsSinceEpoch,
        writeDate: DateTime.timestamp(),
        currentStatus: TimerStatus.running,
        lastTicked: DateTime.timestamp(),
        isFavorite: isFavorite,
      ),
    );
  }
}

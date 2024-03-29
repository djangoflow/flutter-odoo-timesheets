import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';

import 'package:timesheets/features/timesheet/presentation/timesheet_with_task_editor.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class TimesheetAddPage extends StatelessWidget {
  const TimesheetAddPage({
    Key? key,
    this.taskWithProjectExternalData,
    this.disableProjectTaskSelection,
    this.isInitiallyFavorite,
    this.disableLocalProjectTaskSelection,
  }) : super(key: key);
  final TaskWithProjectExternalData? taskWithProjectExternalData;

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
            'Create Timer',
          ),
        ),
        body: TimesheetWithTaskEditor(
          showOnlySyncedTaskAndProjects: disableLocalProjectTaskSelection,
          disableProjectTaskSelection: disableProjectTaskSelection,
          project: taskWithProjectExternalData?.projectWithExternalData,
          task: taskWithProjectExternalData?.taskWithExternalData.task,
          isFavorite: isInitiallyFavorite,
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
                        DjangoflowAppSnackbar.showInfo('Added successfully');
                        await router.pop(true);
                      },
                      action: (_) =>
                          _addTimesheet(context: context, form: form),
                      builder: (context, action, state) => ElevatedButton(
                        onPressed: form.valid ? action : null,
                        child: const Center(
                          child: Text(
                            'Create Timer',
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
    final project =
        (form.control(projectControlName).value as ProjectWithExternalData)
            .project;
    final task = form.control(taskControlName).value as Task;
    final description = form.control(descriptionControlName).value as String;
    final isFavorite = form.control(isFavoriteControlName).value as bool;
    final timesheetRepository = context.read<TimesheetRepository>();

    await timesheetRepository.create(
      TimesheetsCompanion(
        projectId: Value(project.id),
        taskId: Value(task.id),
        name: Value(description),
        isFavorite: Value(isFavorite),
      ),
    );
  }
}

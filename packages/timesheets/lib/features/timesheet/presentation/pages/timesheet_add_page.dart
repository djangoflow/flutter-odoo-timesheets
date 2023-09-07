import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/in_memory_backend/data/in_memory_backend.dart';
import 'package:timesheets/features/in_memory_backend/data/repositories/in_memory_timesheet_with_task_project_repository.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/data/models/task_with_project.dart';

import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_with_task_project_data_cubit/timesheet_with_task_project_data_cubit.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class TimesheetAddPage extends StatelessWidget {
  const TimesheetAddPage({
    Key? key,
    this.taskWithProjectExternalData,
    this.disableProjectTaskSelection,
    this.isInitiallyFavorite,
    this.disableLocalProjectTaskSelection,
  }) : super(key: key);
  final TaskWithProject? taskWithProjectExternalData;

  final bool? disableLocalProjectTaskSelection;

  /// If true, the project and task selection will be disabled.
  /// Needed when only adding a timesheet for specific Project and Task
  final bool? disableProjectTaskSelection;

  final bool? isInitiallyFavorite;

  @override
  Widget build(BuildContext context) =>
      BlocProvider<TimesheetWithTaskProjectDataCubit>(
        create: (context) => TimesheetWithTaskProjectDataCubit(
          repository: InMemoryTimesheetWithTaskProjectRepository(
            backend: context.read<InMemoryBackend>(),
          ),
        ),
        child: GradientScaffold(
          appBar: AppBar(
            leading: const AutoLeadingButton(),
            title: const Text(
              'Create Timer',
            ),
          ),
          body: TimesheetWithTaskProjectEditor(
            // showOnlySyncedTaskAndProjects: disableLocalProjectTaskSelection,
            disableProjectTaskSelection: disableProjectTaskSelection,
            project: taskWithProjectExternalData?.project,
            task: taskWithProjectExternalData?.task,
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
                          DjangoflowAppSnackbar.showInfo('Added successfully');
                          await context.router.pop(true);
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
        ),
      );

  Future<void> _addTimesheet(
      {required BuildContext context, required FormGroup form}) async {
    final project = form.control(projectControlName).value as Project;
    final projectId = project.id;
    if (projectId == null) {
      throw Exception('Project Id is null, please select another Project!');
    }
    final task = form.control(taskControlName).value as Task;
    final taskId = task.id;
    if (taskId == null) {
      throw Exception('Task Id is null, please select another Task!');
    }
    final description = form.control(descriptionControlName).value as String;
    final isFavorite = form.control(isFavoriteControlName).value as bool;
    final cubit = context.read<TimesheetWithTaskProjectDataCubit>();

    await cubit.createItem(
      TimesheetWithTaskProject(
        timesheet: Timesheet(
          projectId: projectId,
          taskId: taskId,
          description: description,
          isFavorite: isFavorite,
        ),
        taskWithProject: TaskWithProject(
          task: task,
          project: project,
        ),
      ),
    );
  }
}

import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:list_bloc/list_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage()
class TimesheetEditPage extends StatelessWidget implements AutoRouteWrapper {
  const TimesheetEditPage({
    super.key,
    @PathParam('id') required this.timesheetId,
  });

  final int timesheetId;

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider<TimesheetRelationalDataCubit>(
        create: (context) => TimesheetRelationalDataCubit(
          context.read<TimesheetRelationalRepository>(),
        )..load(TimesheetRetrieveFilter(id: timesheetId)),
        child: this,
      );

  @override
  Widget build(BuildContext context) => GradientScaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text('Edit Timesheet'),
        ),
        body: BlocBuilder<TimesheetRelationalDataCubit, TimesheetDataState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is Error) {
              return const Center(child: Text('Something went wrong!'));
            }

            if (state.data != null) {
              final timesheet = state.data!;
              return TimesheetWithTaskEditor(
                task: timesheet.task,
                project: timesheet.project,
                description: timesheet.name,
                isFavorite: timesheet.isFavorite,
                additionalControls: {
                  'totalTime': FormControl<String>(
                    value: _formatDuration(
                        Duration(seconds: timesheet.elapsedTime)),
                    validators: [
                      Validators.required,
                      const TimeFormatValidator()
                    ],
                  ),
                },
                additionalChildrenBuilder: (context, form) => [
                  const SizedBox(height: kPadding * 2),
                  ReactiveTextField<String>(
                    formControlName: 'totalTime',
                    decoration: const InputDecoration(
                      labelText: 'Total Time (HH:MM)',
                      hintText: 'Enter total time spent',
                    ),
                    validationMessages: {
                      ValidationMessage.required: (_) =>
                          'Total time is required',
                      'invalidFormat': (_) => 'Invalid time format. Use HH:MM',
                    },
                  ),
                ],
                builder: (context, form, formListView) => Column(
                  children: [
                    Expanded(child: formListView),
                    AdaptiveSafeArea(
                      child: ReactiveFormConsumer(
                        builder: (context, form, child) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kPadding * 2),
                          child: LinearProgressBuilder(
                            onSuccess: () async {
                              final router = context.router;
                              DjangoflowAppSnackbar.showInfo(
                                  'Updated successfully');
                              await router.maybePop(true);
                            },
                            action: (_) => _updateTimesheet(
                                context: context,
                                form: form,
                                timesheet: timesheet),
                            builder: (context, action, state) => ElevatedButton(
                              onPressed: form.valid ? action : null,
                              child: const Center(
                                child: Text('Update Timesheet'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No data available'));
          },
        ),
      );

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes';
  }

  Future<void> _updateTimesheet({
    required BuildContext context,
    required FormGroup form,
    required TimesheetModel timesheet,
  }) async {
    final project = (form.control(projectControlName).value as ProjectModel);
    final task = form.control(taskControlName).value as TaskModel;
    final description = form.control(descriptionControlName).value as String;
    final isFavorite = form.control(isFavoriteControlName).value as bool;
    final totalTimeString = form.control('totalTime').value as String;

    final timeParts = totalTimeString.split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    final totalSeconds = (hours * 3600) + (minutes * 60);

    final updatedTimesheet = timesheet.copyWith(
      projectId: project.id,
      taskId: task.id,
      name: description,
      isFavorite: isFavorite,
      unitAmount: totalSeconds / 3600, // Convert seconds to hours
    );

    final isLocallyUpdatedEntityPresent =
        IdGenerator.isTemporaryId(updatedTimesheet.id) ||
            IdGenerator.isTemporaryId(project.id) ||
            IdGenerator.isTemporaryId(task.id);

    await context.read<TimesheetRelationalDataCubit>().updateItem(
          updatedTimesheet,
          onlyUpdateSecondary: isLocallyUpdatedEntityPresent,
        );
  }
}

class TimeFormatValidator extends Validator<dynamic> {
  const TimeFormatValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value as String?;
    if (value == null || value.isEmpty) {
      return {'required': 'Total time is required'};
    }

    final RegExp timeRegex = RegExp(r'^([0-9]{2}):([0-5][0-9])$');
    if (!timeRegex.hasMatch(value)) {
      return {'invalidFormat': 'Invalid time format. Use HH:MM'};
    }

    return null;
  }
}

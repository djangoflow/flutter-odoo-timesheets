import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/tasks/tasks.dart';
import 'package:timesheets/features/timer/timer.dart';

class ActivityStart extends StatelessWidget {
  const ActivityStart({Key? key}) : super(key: key);

  final _projectControlName = 'selectedProject';
  final _taskControlName = 'selectedTask';
  final _descriptionControlName = 'description';
  final _menuMaxHeight = 300.0;

  FormGroup _formBuilder() => fb.group({
        _projectControlName: FormControl<Project>(
          validators: [
            Validators.required,
          ],
        ),
        _taskControlName: FormControl<Task>(
          validators: [
            Validators.required,
          ],
        ),
        _descriptionControlName: FormControl<String>(
          validators: [
            Validators.required,
          ],
        ),
      });

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = authState.user;
    final taskCubit = context.read<TaskCubit>();

    return ReactiveFormBuilder(
        form: _formBuilder,
        builder: (context, form, child) => AutofillGroup(
              child: Padding(
                padding: const EdgeInsets.all(kPadding * 2),
                child: Column(
                  children: [
                    const SizedBox(
                      height: kPadding * 2,
                    ),
                    BlocBuilder<ProjectCubit, ProjectState>(
                      builder: (context, state) => state.when(
                        initial: () => const Offstage(),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        success: (projects) => ReactiveDropdownField(
                          menuMaxHeight: _menuMaxHeight,
                          isExpanded: true,
                          items: projects
                              .map(
                                (Project value) => DropdownMenuItem<Project>(
                                  value: value,
                                  child: Text(value.name),
                                ),
                              )
                              .toList(),
                          formControlName: _projectControlName,
                          decoration: const InputDecoration(
                            hintText: 'Select project',
                          ),
                          onChanged: (FormControl<Project?> project) {
                            Project? selectedProject =
                                (form.value[_projectControlName] as Project?);
                            if (user != null && selectedProject != null) {
                              taskCubit.loadTasks(
                                projectId: selectedProject.id,
                              );
                            }
                          },
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'Please select project',
                          },
                        ),
                        error: (String message) =>
                            const Text('Error Loading Projects'),
                      ),
                    ),
                    const SizedBox(height: kPadding * 2),
                    StreamBuilder(
                      stream: form.control(_projectControlName).valueChanges,
                      builder: (context, projectSnap) {
                        if (projectSnap.data != null) {
                          return BlocBuilder<TaskCubit, TaskState>(
                            builder: (context, state) => state.when(
                              initial: () => const Offstage(),
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              success: (tasks) => ReactiveDropdownField(
                                menuMaxHeight: _menuMaxHeight,
                                isExpanded: true,
                                items: tasks
                                    .map(
                                      (Task value) => DropdownMenuItem<Task>(
                                        value: value,
                                        child: Text(value.name),
                                      ),
                                    )
                                    .toList(),
                                formControlName: _taskControlName,
                                decoration: const InputDecoration(
                                  hintText: 'Select task',
                                ),
                                onChanged: (_) {
                                  if (!form.valid) {
                                    form.markAsTouched();
                                  }
                                },
                                validationMessages: {
                                  ValidationMessage.required: (_) =>
                                      'Please select task',
                                },
                              ),
                              error: (String message) =>
                                  const Text('Error Loading Tasks'),
                            ),
                          );
                        } else {
                          return const Offstage();
                        }
                      },
                    ),
                    const SizedBox(height: kPadding * 2),
                    ReactiveTextField(
                      formControlName: _descriptionControlName,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: 'Enter Description',
                      ),
                      validationMessages: {
                        ValidationMessage.required: (_) =>
                            'Description is required',
                      },
                      onSubmitted: (_) {
                        if (!form.valid) {
                          form.markAsTouched();
                        }
                      },
                    ),
                    const SizedBox(
                      height: kPadding * 4,
                    ),
                    ReactiveFormConsumer(
                      builder: (context, form, child) => ElevatedButton(
                        onPressed: form.valid
                            ? () {
                                _startWork(context: context, form: form);
                              }
                            : null,
                        child: const Center(
                          child: Text('Start Activity'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  _startWork({required BuildContext context, required FormGroup form}) async {
    final project = form.control(_projectControlName).value as Project;
    final task = form.control(_taskControlName).value as Task;
    final description = form.control(_descriptionControlName).value as String;

    context.read<ActivityCubit>().logActivity(
          startDate: DateTime.now().toUtc(),
          project: project,
          task: task,
          description: description,
        );
    context.read<TimerBloc>().add(const TimerEvent.started());
  }
}

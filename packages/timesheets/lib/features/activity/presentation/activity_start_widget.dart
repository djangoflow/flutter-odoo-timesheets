import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/tasks/tasks.dart';
import 'package:timesheets/features/timer/timer.dart';

class ActivityStart extends StatefulWidget {
  const ActivityStart({Key? key}) : super(key: key);

  @override
  State<ActivityStart> createState() => _ActivityStartState();
}

class _ActivityStartState extends State<ActivityStart> {
  Project? selectedProject;
  Task? selectedTask;
  String? description;

  final projectControlName = 'selectedProject';
  final taskControlName = 'selectedTask';
  final descriptionControlName = 'description';

  FormGroup _formBuilder() => fb.group({
        projectControlName: FormControl<Project>(
          validators: [
            Validators.required,
          ],
          value: selectedProject,
        ),
        taskControlName: FormControl<Task>(
          validators: [
            Validators.required,
          ],
          value: selectedTask,
        ),
        descriptionControlName: FormControl<String>(
          validators: [
            Validators.required,
          ],
          value: description,
        ),
      });

  @override
  Widget build(BuildContext context) {
    AuthState authState = context.watch<AuthCubit>().state;
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
                          menuMaxHeight: 300,
                          isExpanded: true,
                          items: projects
                              .map(
                                (Project value) => DropdownMenuItem<Project>(
                                  value: value,
                                  child: Text(value.name),
                                ),
                              )
                              .toList(),
                          formControlName: projectControlName,
                          decoration: const InputDecoration(
                            hintText: 'Select project',
                          ),
                          onChanged: (FormControl<Project?> project) {
                            Project? selectedProject =
                                (form.value[projectControlName] as Project?);
                            if (user != null && selectedProject != null) {
                              taskCubit.loadTasks(
                                id: user.id,
                                projectId: selectedProject.id,
                                password: authState.password!,
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
                      stream: form.control(projectControlName).valueChanges,
                      builder: (context, projectSnap) {
                        if (projectSnap.data != null) {
                          return BlocBuilder<TaskCubit, TaskState>(
                            builder: (context, state) => state.when(
                              initial: () => const Offstage(),
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              success: (tasks) => ReactiveDropdownField(
                                menuMaxHeight: 300,
                                isExpanded: true,
                                items: tasks
                                    .map(
                                      (Task value) => DropdownMenuItem<Task>(
                                        value: value,
                                        child: Text(value.name),
                                      ),
                                    )
                                    .toList(),
                                formControlName: taskControlName,
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
                      formControlName: descriptionControlName,
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
                      height: kPadding * 2,
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
    Project project = form.control(projectControlName).value as Project;
    Task task = form.control(taskControlName).value as Task;
    String description = form.control(descriptionControlName).value as String;

    context.read<ActivityCubit>().logActivity(
          startDate: DateTime.now().toUtc(),
          project: project,
          task: task,
          description: description,
        );
    context.read<TimerBloc>().add(const TimerEvent.started());
  }
}

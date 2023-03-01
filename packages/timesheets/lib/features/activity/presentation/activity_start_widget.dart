import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/tasks/tasks.dart';
import 'package:timesheets/features/timer/timer.dart';

class ActivityStart extends StatelessWidget {
  const ActivityStart({Key? key}) : super(key: key);

  FormGroup _formBuilder() => fb.group({
        projectControlName: FormControl<Project>(
          validators: [
            Validators.required,
          ],
        ),
        taskControlName: FormControl<Task>(
          validators: [
            Validators.required,
          ],
        ),
        descriptionControlName: FormControl<String>(
          validators: [
            Validators.required,
          ],
        ),
      });

  @override
  Widget build(BuildContext context) {
    final taskListCubit = context.read<TaskListCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProjectListCubit>(
          create: (context) => ProjectListCubit(
            context.read<ProjectRepository>(),
          )..load(
              const ProjectListFilter(),
            ),
        ),
        BlocProvider<TaskListCubit>(
          create: (context) => TaskListCubit(
            context.read<TaskRepository>(),
          ),
        ),
        // TODO provide other cubits here as well
      ],
      child: ReactiveFormBuilder(
          form: _formBuilder,
          builder: (context, form, child) => AutofillGroup(
                child: Padding(
                  padding: const EdgeInsets.all(kPadding * 2),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: kPadding * 2,
                      ),
                      BlocBuilder<ProjectListCubit,
                          Data<List<Project>, ProjectListFilter>>(
                        builder: (context, state) {
                          if (state is Loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is Empty) {
                            return const Center(
                              child: Text('No Projects Found'),
                            );
                          }

                          return AppReactiveDropdown<Project, Project>(
                            formControlName: projectControlName,
                            hintText: 'Select Project',
                            itemAsString: (project) => project.name,
                            onBeforeChange: (prevProject, newProject) {
                              if (newProject == null) {
                                return Future.value(false);
                              }

                              if (prevProject == null ||
                                  prevProject.id != newProject.id) {
                                form.control(taskControlName).reset();
                                taskListCubit.load(
                                  TaskListFilter(projectId: newProject.id),
                                );
                                return Future.value(true);
                              }

                              return Future.value(false);
                            },
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  'Please select project',
                            },
                            asyncItems: (searchTerm) async {
                              if (searchTerm.isNotEmpty) {
                                final projectListCubit =
                                    context.read<ProjectListCubit>();
                                return await projectListCubit.loader(
                                  state.filter?.copyWith(search: searchTerm),
                                );
                              }

                              return state.data ?? [];
                            },
                          );
                        },
                        // loadingBuilder: (context, data) => const Center(
                        //   child: CircularProgressIndicator(),
                        // ),
                        // emptyBuilder: (context, data) => const Center(
                        //   child: Text('No Projects Found'),
                        // ),
                        // builder: (context, state, index, itemBuilder) =>
                        //     itemBuilder.call(context, index - 1),
                      ),
                      const SizedBox(height: kPadding * 2),
                      StreamBuilder<Project>(
                        stream: form.control(projectControlName).valueChanges
                            as Stream<Project>,
                        builder: (context, projectSnap) {
                          if (projectSnap.data != null) {
                            // TODO use BlocBuilder, and provide cubit above it.
                            return ListBlocBuilder<TaskListCubit, Task,
                                TaskListFilter>(
                              create: (context) =>
                                  TaskListCubit(context.read<TaskRepository>())
                                    ..load(TaskListFilter(
                                        projectId: projectSnap.data!.id)),
                              loadingBuilder: (context, data) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              emptyBuilder: (context, data) => const Center(
                                child: Text('No Tasks Found'),
                              ),
                              builder: (context, state, index, itemBuilder) =>
                                  itemBuilder.call(context, index - 1),
                              itemBuilder: (context, state, index, project) =>
                                  AppReactiveDropdown<Task, Task>(
                                itemAsString: (task) => task.name,
                                asyncItems: (searchTerm) async {
                                  if (searchTerm.isNotEmpty) {
                                    return await taskListCubit.loader(
                                      state.filter
                                          ?.copyWith(search: searchTerm),
                                    );
                                  }

                                  return state.data ?? [];
                                },
                                formControlName: taskControlName,
                                hintText: 'Select task',
                                validationMessages: {
                                  ValidationMessage.required: (_) =>
                                      'Please select task',
                                },
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
              )),
    );
  }

  _startWork({required BuildContext context, required FormGroup form}) async {
    final project = form.control(projectControlName).value as Project;
    final task = form.control(taskControlName).value as Task;
    final description = form.control(descriptionControlName).value as String;

    context.read<ActivityCubit>().logActivity(
          startDate: DateTime.now().toUtc(),
          project: project,
          task: task,
          description: description,
        );
    context.read<TimerBloc>().add(const TimerEvent.started());
  }
}

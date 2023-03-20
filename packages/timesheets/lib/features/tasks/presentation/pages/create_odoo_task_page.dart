import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/tasks/tasks.dart';
import 'package:timesheets/features/timer/timer.dart';

class CreateOdooTaskPage extends StatelessWidget {
  const CreateOdooTaskPage({Key? key}) : super(key: key);

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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(kPadding * 2),
          child: Text(
            'Add Task',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        centerTitle: true,
      ),
      body: ReactiveFormBuilder(
        form: _formBuilder,
        builder: (context, form, child) => AutofillGroup(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding * 2),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    kPadding * 2,
                  ),
                  child: Text(
                    'You can add an independent task or synchronize with your task with Odoo or Github',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: kPadding * 2),
                RepositoryProvider<ProjectRepository>(
                  create: (context) => ProjectRepository(
                    context.read<AppXmlRpcClient>(),
                  ),
                  child: BlocProvider<ProjectListCubit>(
                    create: (context) => ProjectListCubit(
                      context.read<ProjectRepository>(),
                    )..load(
                        const ProjectListFilter(),
                      ),
                    child: BlocBuilder<ProjectListCubit,
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
                    ),
                  ),
                ),
                ReactiveValueListenableBuilder<Project>(
                  formControlName: projectControlName,
                  builder: (context, control, child) {
                    final project = control.value;

                    if (project != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: kPadding * 2),
                        child: RepositoryProvider(
                          key: ObjectKey(project),
                          create: (context) => TaskRepository(
                            context.read<AppXmlRpcClient>(),
                          ),
                          child: BlocProvider(
                            create: (context) => TaskListCubit(
                              context.read<TaskRepository>(),
                            )..load(
                                TaskListFilter(projectId: project.id),
                              ),
                            child: BlocBuilder<TaskListCubit,
                                Data<List<Task>, TaskListFilter>>(
                              builder: (context, state) {
                                if (state is Loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is Empty) {
                                  return const Center(
                                    child: Text('No Tasks Found'),
                                  );
                                }

                                return AppReactiveDropdown<Task, Task>(
                                  itemAsString: (task) => task.name,
                                  asyncItems: (searchTerm) async {
                                    if (searchTerm.isNotEmpty) {
                                      final taskListCubit =
                                          context.read<TaskListCubit>();
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
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                    return const Offstage();
                  },
                ),
                const SizedBox(height: kPadding * 2),
                ReactiveTextField(
                  formControlName: descriptionControlName,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    hintText: 'Description',
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                    ),
                    onPressed: form.valid
                        ? () {
                            _startWork(context: context, form: form);
                          }
                        : null,
                    child: const Center(
                      child: Text('Add task'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

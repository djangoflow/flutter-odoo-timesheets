import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

class TimesheetWithTaskEditor extends StatelessWidget {
  const TimesheetWithTaskEditor({
    super.key,
    this.description,
    required this.builder,
    this.task,
    this.project,
    this.additionalChildrenBuilder,
    this.showOnlySyncedTaskAndProjects,
    this.disableProjectTaskSelection,
    this.isFavorite,
  });

  final Task? task;
  final String? description;
  final ProjectWithExternalData? project;
  final List<Widget> Function(BuildContext context)? additionalChildrenBuilder;
  final bool? showOnlySyncedTaskAndProjects;
  final bool? disableProjectTaskSelection;
  final bool? isFavorite;

  final Widget Function(
      BuildContext context, FormGroup form, Widget formListView) builder;

  FormGroup get _formGroup => fb.group(
        {
          projectControlName: FormControl<ProjectWithExternalData>(
            value: project,
            disabled: disableProjectTaskSelection == true ? true : false,
            validators: [
              Validators.required,
            ],
          ),
          taskControlName: FormControl<Task>(
            value: task,
            disabled: disableProjectTaskSelection == true ? true : false,
            validators: [
              Validators.required,
            ],
          ),
          descriptionControlName: FormControl<String>(
            value: description,
            validators: [
              Validators.required,
            ],
          ),
          isFavoriteControlName: FormControl<bool>(
            value: isFavorite ?? false,
          ),
        },
      );

  @override
  Widget build(BuildContext context) => ReactiveFormBuilder(
        form: () => _formGroup,
        builder: (context, formGroup, child) {
          final formListView = GestureDetector(
            onTap: () => formGroup.unfocus(),
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: kPadding.h * 2,
                vertical: kPadding.w * 2,
              ),
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: kPadding.h * 2,
                ),
                BlocProvider<ProjectListCubit>(
                  create: (context) => ProjectListCubit(
                    context.read<ProjectRepository>(),
                  )..load(
                      ProjectListFilter(
                        isLocal: showOnlySyncedTaskAndProjects == true
                            ? false
                            : null,
                      ),
                    ),
                  child: BlocBuilder<ProjectListCubit, ProjectListState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return AppReactiveTypeAhead<ProjectWithExternalData,
                          ProjectWithExternalData>(
                        formControlName: projectControlName,
                        labelText: 'Project',
                        hintText: 'Select Project',
                        emptyBuilder: (_, textEditingController) =>
                            AppGlassContainer(
                          child: _EmptyItem(
                            label: 'Project',
                            searchTerm: textEditingController.value.text,
                            onCreatePressed: () async {
                              final router = context.router;
                              final projectListCubit =
                                  context.read<ProjectListCubit>();
                              final createdProject =
                                  await projectListCubit.createProject(
                                ProjectsCompanion(
                                  name: Value(
                                    textEditingController.value.text,
                                  ),
                                  taskCount: const Value(0),
                                  active: const Value(true),
                                ),
                              );
                              if (createdProject != null) {
                                formGroup.control(projectControlName).value =
                                    ProjectWithExternalData(
                                  project: createdProject,
                                );
                                projectListCubit.reload();
                                router.pop();
                              }
                            },
                          ),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'Please select project',
                        },
                        stringify: (value) => value.project.name ?? '',
                        suggestionsCallback: (String searchTerm) async {
                          if (searchTerm.isNotEmpty) {
                            final projectListCubit =
                                context.read<ProjectListCubit>();
                            final result = await projectListCubit.loader(
                              state.filter?.copyWith(
                                search: searchTerm,
                              ),
                            );

                            return result;
                          }

                          return state.data ?? [];
                        },
                        itemBuilder: (context, itemData) => Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: kPadding.h / 2),
                          child: ListTile(
                            tileColor: Colors.transparent,
                            title: Text(
                              itemData.project.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: kPadding.h * 2),
                ReactiveValueListenableBuilder<ProjectWithExternalData>(
                  formControlName: projectControlName,
                  builder: (context, control, child) {
                    final projectWithExternalData = control.value;
                    final project = projectWithExternalData?.project;

                    if (project != null) {
                      return RepositoryProvider(
                        key: ObjectKey(project),
                        create: (context) => OdooTaskRepository(
                          context.read<OdooXmlRpcClient>(),
                        ),
                        child: BlocProvider<TaskListCubit>(
                          create: (context) => TaskListCubit(
                            odooTimesheetRepository:
                                context.read<OdooTimesheetRepository>(),
                            taskRepository: context.read<TaskRepository>(),
                          )..load(
                              TaskListFilter(
                                projectId: project.id,
                              ),
                            ),
                          child: BlocBuilder<
                              TaskListCubit,
                              Data<List<TaskWithProjectExternalData>,
                                  TaskListFilter>>(
                            builder: (context, state) {
                              if (state is Loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return AppReactiveTypeAhead<Task, Task>(
                                stringify: (task) => task.name ?? '',
                                labelText: 'Task',
                                formControlName: taskControlName,
                                hintText: 'Select task',
                                validationMessages: {
                                  ValidationMessage.required: (_) =>
                                      'Please select task',
                                },
                                itemBuilder: (context, task) => ListTile(
                                  tileColor: Colors.transparent,
                                  title: Text(
                                    task.name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                suggestionsCallback: (searchTerm) async {
                                  if (searchTerm.isNotEmpty) {
                                    final taskListCubit =
                                        context.read<TaskListCubit>();
                                    return (await taskListCubit.loader(
                                      state.filter
                                          ?.copyWith(search: searchTerm),
                                    ))
                                        .map((e) => e.taskWithExternalData.task)
                                        .toList();
                                  }

                                  return state.data
                                          ?.map((e) =>
                                              e.taskWithExternalData.task)
                                          .toList() ??
                                      [];
                                },
                                emptyBuilder: (_, textEditingController) {
                                  final searchTerm =
                                      textEditingController.value.text;

                                  return AppGlassContainer(
                                    child: _EmptyItem(
                                      label: 'Task',
                                      searchTerm: searchTerm,
                                      onCreatePressed: () async {
                                        final router = context.router;
                                        final taskListCubit =
                                            context.read<TaskListCubit>();
                                        final createdTask =
                                            await taskListCubit.createTask(
                                          TasksCompanion(
                                            name: Value(searchTerm),
                                            projectId: Value(project.id),
                                            active: const Value(true),
                                          ),
                                        );
                                        if (createdTask != null) {
                                          formGroup
                                              .control(taskControlName)
                                              .value = createdTask;
                                          taskListCubit.reload();
                                          router.pop();
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return const Offstage();
                  },
                ),
                SizedBox(height: kPadding.h * 2),
                ReactiveTextField(
                  formControlName: descriptionControlName,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.multiline,
                  autofocus: disableProjectTaskSelection == true,
                  maxLines: 3,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Enter Description',
                    labelText: 'Description',
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) =>
                        'Description is required',
                  },
                  onSubmitted: (_) {
                    if (!formGroup.valid) {
                      formGroup.markAsTouched();
                    }
                  },
                ),
                if (disableProjectTaskSelection == true) ...[
                  SizedBox(
                    height: kPadding.h,
                  ),
                  const Text('Just enter a description and start to work!'),
                ],
                SizedBox(
                  height: kPadding.h * 2,
                ),
                Row(
                  children: [
                    ReactiveCheckbox(
                      formControlName: isFavoriteControlName,
                    ),
                    SizedBox(
                      width: kPadding.w,
                    ),
                    Text(
                      'Make Favorite',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
                if (additionalChildrenBuilder != null)
                  ...additionalChildrenBuilder!(context),
              ],
            ),
          );

          return builder(context, formGroup, formListView);
        },
      );
}

class _EmptyItem extends StatelessWidget {
  const _EmptyItem(
      {super.key,
      required this.searchTerm,
      required this.onCreatePressed,
      required this.label});
  final String searchTerm;
  final String label;
  final VoidCallback? onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kPadding.w * 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: 'No ${label}s Found. ',
                children: [
                  if (searchTerm.isNotEmpty) ...[
                    const TextSpan(
                      text: 'But you can create one named ',
                    ),
                    TextSpan(
                      text: searchTerm,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ] else ...[
                    TextSpan(
                      text: 'Type something to search or Add a new $label.',
                    ),
                  ],
                ],
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: kPadding.h * 2,
            ),
            if (searchTerm.isNotEmpty)
              ElevatedButton(
                onPressed: onCreatePressed,
                child: Text('Create this $label'),
              ),
          ],
        ),
      ),
    );
  }
}

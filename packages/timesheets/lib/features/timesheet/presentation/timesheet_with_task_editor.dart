import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:list_bloc/list_bloc.dart';
import 'package:reactive_flutter_typeahead/reactive_flutter_typeahead.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/sync/sync.dart';
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
    this.additionalControls = const {},
  });

  final TaskModel? task;
  final ProjectModel? project;
  final String? description;

  final List<Widget> Function(BuildContext context, FormGroup form)?
      additionalChildrenBuilder;
  final Map<String, AbstractControl<dynamic>> additionalControls;

  final bool? showOnlySyncedTaskAndProjects;
  final bool? disableProjectTaskSelection;
  final bool? isFavorite;

  final Widget Function(
      BuildContext context, FormGroup form, Widget formListView) builder;

  FormGroup get _formGroup {
    final baseControls = {
      projectControlName: FormControl<ProjectModel>(
        value: task?.project ?? project,
        disabled: disableProjectTaskSelection == true ? true : false,
        validators: [Validators.required],
      ),
      taskControlName: FormControl<TaskModel>(
        value: task,
        disabled: disableProjectTaskSelection == true ? true : false,
        validators: [Validators.required],
      ),
      descriptionControlName: FormControl<String>(
        value: description,
        validators: [Validators.required],
      ),
      isFavoriteControlName: FormControl<bool>(
        value: isFavorite ?? false,
      ),
    };

    // Merge base controls with additional controls
    return FormGroup({...baseControls, ...additionalControls});
  }

  @override
  Widget build(BuildContext context) {
    final projectSuggestionBoxController = SuggestionsBoxController();
    final taskSuggestionBoxController = SuggestionsBoxController();
    return MultiSyncProvider(
      configs: [
        SyncProviderConfig<ProjectModel, ProjectRepository>(
          odooModelName: ProjectModel.odooModelName,
          repositoryBuilder: (context) => context.read<ProjectRepository>(),
        ),
        SyncProviderConfig<TaskModel, TaskRepository>(
          odooModelName: TaskModel.odooModelName,
          repositoryBuilder: (context) => context.read<TaskRepository>(),
        ),
      ],
      builder: (context, backendId) => ReactiveFormBuilder(
        form: () => _formGroup,
        builder: (context, formGroup, child) {
          final formListView = ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: kPadding * 2,
              vertical: kPadding * 2,
            ),
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: kPadding * 2,
              ),
              _ProjectSelector(
                projectSuggestionBoxController: projectSuggestionBoxController,
                showOnlySyncedTaskAndProjects: showOnlySyncedTaskAndProjects,
              ),
              const SizedBox(height: kPadding * 2),
              _TaskSelector(
                taskSuggestionBoxController: taskSuggestionBoxController,
                showOnlySyncedTaskAndProjects: showOnlySyncedTaskAndProjects,
              ),
              const SizedBox(height: kPadding * 2),
              _DescriptionField(
                disableProjectTaskSelection:
                    disableProjectTaskSelection == true,
              ),
              if (disableProjectTaskSelection == true) ...[
                const SizedBox(
                  height: kPadding,
                ),
                const Text('Just enter a description and start to work!'),
              ],
              const SizedBox(
                height: kPadding * 2,
              ),
              const _IsFavoriteCheckbox(),
              if (additionalChildrenBuilder != null)
                ...additionalChildrenBuilder!(context, formGroup),
            ],
          );

          return builder(context, formGroup, formListView);
        },
      ),
    );
  }
}

class _EmptyItem extends StatelessWidget {
  const _EmptyItem(
      {required this.searchTerm,
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
        padding: const EdgeInsets.symmetric(
          horizontal: kPadding * 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.info_circle,
              size: kPadding * 6,
            ),
            const SizedBox(
              height: kPadding * 2,
            ),
            RichText(
              text: TextSpan(
                text: 'No ${label}s Found. ',
                children: [
                  if (searchTerm.isNotEmpty && onCreatePressed != null) ...[
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
                      text:
                          'Type something else to search or Create a new $label.',
                    ),
                  ],
                ],
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: kPadding * 2,
            ),
            if (searchTerm.isNotEmpty && onCreatePressed != null)
              TextFieldTapRegion(
                child: ElevatedButton(
                  onPressed: onCreatePressed,
                  child: Text('Create this $label'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProjectSelector extends StatelessWidget {
  const _ProjectSelector({
    required this.projectSuggestionBoxController,
    this.showOnlySyncedTaskAndProjects,
  });

  final SuggestionsBoxController projectSuggestionBoxController;
  final bool? showOnlySyncedTaskAndProjects;

  @override
  Widget build(BuildContext context) => BlocProvider<ProjectListCubit>(
        create: (context) => ProjectListCubit(
          context.read<ProjectRepository>(),
        )..load(
            const ProjectListFilter(),
          ),
        child: BlocConsumer<ProjectListCubit, ProjectListState>(
          listenWhen: (previous, current) => previous.data != current.data,
          listener: (context, state) {
            if (state.data != null) {
              context.syncCubitFor<ProjectModel>().loadPendingSyncRegistries(
                    ids: state.data!.map((e) => e.id).toList(),
                  );
            }
          },
          builder: (context, state) {
            if (state is Loading) {
              return const Center(
                child: ParticleLoadingIndicator(),
              );
            }

            final pendingProjectSyncRecords = context
                .watch<SyncCubit<ProjectModel>>()
                .state
                .pendingSyncRecordIds;
            return AppReactiveTypeAhead<ProjectModel, ProjectModel>(
              formControlName: projectControlName,
              suggestionsBoxController: projectSuggestionBoxController,
              inputDecoration: InputDecoration(
                labelText: 'Project',
                hintText: 'Select Project',
                suffixIcon: ReactiveValueListenableBuilder(
                  formControlName: projectControlName,
                  builder: (context, control, child) {
                    final project = control.value as ProjectModel?;

                    if (project == null) {
                      return const SizedBox();
                    } else {
                      return StorageIcon(
                        !(pendingProjectSyncRecords?.contains(project.id) ??
                            true),
                      );
                    }
                  },
                ),
              ),
              emptyBuilder: (_, textEditingController) => AppGlassContainer(
                child: _EmptyItem(
                  label: 'Project',
                  searchTerm: textEditingController.value.text,
                  onCreatePressed: showOnlySyncedTaskAndProjects == true
                      ? null
                      : () => _onProjectCreate(
                            context: context,
                            name: textEditingController.value.text,
                          ),
                ),
              ),
              validationMessages: {
                ValidationMessage.required: (_) => 'Please select project',
              },
              stringify: (value) => value.name,
              suggestionsCallback: (String searchTerm) async {
                if (searchTerm.isNotEmpty) {
                  final projectListCubit = context.read<ProjectListCubit>();
                  final result = await projectListCubit.loader(
                    state.filter?.copyWith(
                      search: searchTerm,
                    ),
                  );

                  return result;
                }

                return state.data ?? [];
              },
              itemBuilder: (context, itemData) => TextFieldTapRegion(
                child: Padding(
                  key: ValueKey(itemData.id),
                  padding: const EdgeInsets.symmetric(vertical: kPadding / 2),
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Text(
                      itemData.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: StorageIcon(
                      !(pendingProjectSyncRecords?.contains(itemData.id) ??
                          true),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Future<void> _onProjectCreate({
    required BuildContext context,
    required String name,
  }) async {
    final projectListCubit = context.read<ProjectListCubit>();
    final formGroup = ReactiveForm.of(context) as FormGroup;
    final createdProject = await projectListCubit.createItem(
      ProjectModel(
        name: name,
        active: true,
        id: DateTime.timestamp().millisecondsSinceEpoch,
        isFavorite: false,
        taskCount: 0,
        createDate: DateTime.timestamp(),
        writeDate: DateTime.timestamp(),
      ),
    );
    if (createdProject != null) {
      formGroup.control(projectControlName).value = createdProject;
      projectListCubit.reload();
      projectSuggestionBoxController.close();
    }
  }
}

class _TaskSelector extends StatefulWidget {
  const _TaskSelector({
    required this.taskSuggestionBoxController,
    this.showOnlySyncedTaskAndProjects,
  });
  final SuggestionsBoxController taskSuggestionBoxController;
  final bool? showOnlySyncedTaskAndProjects;

  @override
  State<_TaskSelector> createState() => _TaskSelectorState();
}

class _TaskSelectorState extends State<_TaskSelector> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final formGroup = (ReactiveForm.of(context) as FormGroup);

    formGroup.control(projectControlName).valueChanges.listen((event) {
      final taskControl = formGroup.control(taskControlName);
      taskControl.value = null;
      taskControl.markAsUntouched();
    });
  }

  @override
  Widget build(BuildContext context) =>
      ReactiveValueListenableBuilder<ProjectModel>(
        formControlName: projectControlName,
        builder: (context, control, child) {
          final project = control.value;

          if (project != null) {
            return BlocProvider<TaskListCubit>(
              key: ValueKey(project.id),
              create: (context) => TaskListCubit(
                context.read<TaskRepository>(),
              )..load(
                  TaskListFilter(
                    projectId: project.id,
                  ),
                ),
              child: BlocConsumer<TaskListCubit, TaskListState>(
                listenWhen: (previous, current) =>
                    previous.data != current.data,
                listener: (context, state) {
                  if (state.data != null) {
                    context.syncCubitFor<TaskModel>().loadPendingSyncRegistries(
                          ids: state.data!.map((e) => e.id).toList(),
                        );
                  }
                },
                builder: (context, state) {
                  if (state is Loading) {
                    return const Center(
                      child: ParticleLoadingIndicator(),
                    );
                  }
                  final pendingTaskSyncRecords = context
                      .watch<SyncCubit<TaskModel>>()
                      .state
                      .pendingSyncRecordIds;
                  return AppReactiveTypeAhead<TaskModel, TaskModel>(
                    formControlName: taskControlName,
                    suggestionsBoxController:
                        widget.taskSuggestionBoxController,
                    stringify: (task) => task.name,
                    inputDecoration: InputDecoration(
                      labelText: 'Task',
                      hintText: 'Select task',
                      suffixIcon: ReactiveValueListenableBuilder(
                        formControlName: taskControlName,
                        builder: (context, control, child) {
                          final task = control.value as TaskModel?;

                          if (task == null) {
                            return const SizedBox();
                          } else {
                            return StorageIcon(
                              !(pendingTaskSyncRecords?.contains(task.id) ??
                                  true),
                            );
                          }
                        },
                      ),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (_) => 'Please select task',
                    },
                    itemBuilder: (context, task) => TextFieldTapRegion(
                      child: ListTile(
                        key: ValueKey(task.id),
                        tileColor: Colors.transparent,
                        title: Text(
                          task.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: StorageIcon(
                          !(pendingTaskSyncRecords?.contains(task.id) ?? true),
                        ),
                      ),
                    ),
                    suggestionsCallback: (searchTerm) async {
                      if (searchTerm.isNotEmpty) {
                        final taskListCubit = context.read<TaskListCubit>();
                        return (await taskListCubit.loader(
                          state.filter?.copyWith(search: searchTerm),
                        ));
                      }

                      return state.data ?? [];
                    },
                    emptyBuilder: (_, textEditingController) {
                      final searchTerm = textEditingController.value.text;

                      return AppGlassContainer(
                        child: _EmptyItem(
                          label: 'Task',
                          searchTerm: searchTerm,
                          onCreatePressed: () => _onTaskCreate(
                            context: context,
                            project: project,
                            searchTerm: searchTerm,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          return const Offstage();
        },
      );

  Future<void> _onTaskCreate({
    required BuildContext context,
    required ProjectModel project,
    required String searchTerm,
  }) async {
    final taskListCubit = context.read<TaskListCubit>();
    final formGroup = ReactiveForm.of(context) as FormGroup;

    final createdTask = await taskListCubit.createItem(
      TaskModel(
        name: searchTerm,
        projectId: project.id,
        active: true,
        id: DateTime.timestamp().millisecondsSinceEpoch,
        createDate: DateTime.timestamp(),
        writeDate: DateTime.timestamp(),
      ),
    );

    if (createdTask != null) {
      formGroup.control(taskControlName).value = createdTask;
      taskListCubit.reload();
      widget.taskSuggestionBoxController.close();
    }
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({this.disableProjectTaskSelection});
  final bool? disableProjectTaskSelection;

  @override
  Widget build(BuildContext context) => ReactiveTextField(
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
          ValidationMessage.required: (_) => 'Description is required',
        },
        onSubmitted: (_) {
          final formGroup = ReactiveForm.of(context) as FormGroup;
          if (!formGroup.valid) {
            formGroup.markAsTouched();
          }
        },
      );
}

class _IsFavoriteCheckbox extends StatelessWidget {
  const _IsFavoriteCheckbox();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ReactiveCheckbox(
            formControlName: isFavoriteControlName,
          ),
          const SizedBox(
            width: kPadding,
          ),
          Text(
            'Make Favorite',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      );
}

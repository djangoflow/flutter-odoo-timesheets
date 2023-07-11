import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/odoo/odoo.dart';

class OdooTaskEditor extends StatelessWidget {
  const OdooTaskEditor({
    super.key,
    this.description,
    required this.builder,
    this.odooTask,
    this.odooProject,
    this.additionalChildrenBuilder,
  });

  final OdooTask? odooTask;
  final String? description;
  final OdooProject? odooProject;
  final List<Widget> Function(BuildContext context)? additionalChildrenBuilder;

  final Widget Function(
      BuildContext context, FormGroup form, Widget formListView) builder;

  FormGroup get _formGroup => fb.group(
        {
          projectControlName: FormControl<OdooProject>(
            value: odooProject,
            validators: [
              Validators.required,
            ],
          ),
          taskControlName: FormControl<OdooTask>(
            value: odooTask,
            validators: [
              Validators.required,
            ],
          ),
          descriptionControlName: FormControl<String>(
            value: description,
            validators: [],
          ),
        },
      );

  @override
  Widget build(BuildContext context) => ReactiveFormBuilder(
        form: () => _formGroup,
        builder: (context, formGroup, child) {
          final formListView = ListView(
            padding: EdgeInsets.symmetric(
              horizontal: kPadding.h * 2,
              vertical: kPadding.w * 2,
            ),
            shrinkWrap: true,
            children: [
              SizedBox(
                height: kPadding.h * 2,
              ),
              RepositoryProvider<OdooProjectRepository>(
                create: (context) => OdooProjectRepository(
                  context.read<OdooXmlRpcClient>(),
                ),
                child: BlocProvider<OdooProjectListCubit>(
                  create: (context) => OdooProjectListCubit(
                    context.read<OdooProjectRepository>(),
                  )..load(
                      const OdooProjectListFilter(),
                    ),
                  child: BlocBuilder<OdooProjectListCubit,
                      Data<List<OdooProject>, OdooProjectListFilter>>(
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
                      return AppReactiveDropdown<OdooProject, OdooProject>(
                        formControlName: projectControlName,
                        labelText: 'Project',
                        hintText: 'Select Project',
                        itemAsString: (project) => project.name,
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'Please select project',
                        },
                        asyncItems: (searchTerm) async {
                          if (searchTerm.isNotEmpty) {
                            final projectListCubit =
                                context.read<OdooProjectListCubit>();
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
              SizedBox(height: kPadding.h * 2),
              ReactiveValueListenableBuilder<OdooProject>(
                formControlName: projectControlName,
                builder: (context, control, child) {
                  final project = control.value;

                  if (project != null) {
                    return RepositoryProvider(
                      key: ObjectKey(project),
                      create: (context) => OdooTaskRepository(
                        context.read<OdooXmlRpcClient>(),
                      ),
                      child: BlocProvider(
                        create: (context) => OdooTaskListCubit(
                          context.read<OdooTaskRepository>(),
                        )..load(
                            OdooTaskListFilter(projectId: project.id),
                          ),
                        child: BlocBuilder<OdooTaskListCubit,
                            Data<List<OdooTask>, OdooTaskListFilter>>(
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

                            return AppReactiveDropdown<OdooTask, OdooTask>(
                              itemAsString: (task) => task.name,
                              labelText: 'Task',
                              asyncItems: (searchTerm) async {
                                if (searchTerm.isNotEmpty) {
                                  final taskListCubit =
                                      context.read<OdooTaskListCubit>();
                                  return await taskListCubit.loader(
                                    state.filter?.copyWith(search: searchTerm),
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
                    );
                  }
                  return const Offstage();
                },
              ),
              SizedBox(height: kPadding.h * 2),
              ReactiveTextField(
                formControlName: descriptionControlName,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.none,
                decoration: const InputDecoration(
                  hintText: 'Enter Description',
                  labelText: 'Description',
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Description is required',
                },
                onSubmitted: (_) {
                  if (!formGroup.valid) {
                    formGroup.markAsTouched();
                  }
                },
              ),
              if (additionalChildrenBuilder != null)
                ...additionalChildrenBuilder!(context),
            ],
          );

          return builder(context, formGroup, formListView);
        },
      );
}

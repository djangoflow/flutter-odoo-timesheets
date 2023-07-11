import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

import 'package:timesheets/features/odoo/odoo.dart';

@RoutePage()
class OdooTaskAddPage extends StatelessWidget {
  const OdooTaskAddPage({Key? key}) : super(key: key);

  FormGroup _formBuilder() => fb.group({
        projectControlName: FormControl<OdooProject>(
          validators: [
            Validators.required,
          ],
        ),
        taskControlName: FormControl<OdooTask>(
          validators: [
            Validators.required,
          ],
        ),
        descriptionControlName: FormControl<String>(
          validators: [],
        ),
      });

  @override
  Widget build(BuildContext context) => ReactiveFormBuilder(
        form: _formBuilder,
        builder: (context, form, child) => AutofillGroup(
          child: Padding(
            padding: EdgeInsets.all(kPadding.w * 2),
            child: Column(
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
                                asyncItems: (searchTerm) async {
                                  if (searchTerm.isNotEmpty) {
                                    final taskListCubit =
                                        context.read<OdooTaskListCubit>();
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
                SizedBox(
                  height: kPadding.h * 4,
                ),
                ReactiveFormConsumer(
                  builder: (context, form, child) => ElevatedButton(
                    onPressed: form.valid
                        ? () {
                            _addOdooTimesheet(context: context, form: form);
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
        ),
      );

  _addOdooTimesheet(
      {required BuildContext context, required FormGroup form}) async {
    final project = form.control(projectControlName).value as OdooProject;
    final task = form.control(taskControlName).value as OdooTask;
    final description = form.control(descriptionControlName).value as String;

    // TODO Initial entry in timesheet
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';

class TaskEditor extends StatelessWidget {
  const TaskEditor({
    super.key,
    this.taskName,
    this.description,
    this.projectName,
    required this.builder,
  });

  final String? taskName;
  final String? description;
  final String? projectName;

  final Widget Function(
      BuildContext context, FormGroup form, Widget formListView) builder;

  FormGroup get _formGroup => fb.group(
        {
          taskControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
            value: taskName,
          ),
          projectControlName: FormControl<String>(
            value: projectName,
          ),
          descriptionControlName: FormControl<String>(
            value: description,
          ),
        },
      );

  @override
  Widget build(BuildContext context) => ReactiveFormBuilder(
      form: () => _formGroup,
      builder: (context, formGroup, child) {
        final formListView = ListView(
          padding: EdgeInsets.all(kPadding.w * 2),
          children: [
            ReactiveTextField<String>(
              formControlName: taskControlName,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(
              height: kPadding.h * 3,
            ),
            ReactiveTextField<String>(
              formControlName: projectControlName,
              decoration: const InputDecoration(
                labelText: 'Project',
                helperText: 'Optional',
              ),
            ),
            SizedBox(
              height: kPadding.h * 3,
            ),
            ReactiveTextField<String>(
              formControlName: descriptionControlName,
              decoration: const InputDecoration(
                labelText: 'Description',
                helperText: 'Optional',
              ),
            ),
          ],
        );

        return builder(context, formGroup, formListView);
      });
}

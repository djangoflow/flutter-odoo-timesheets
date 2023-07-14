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
    this.additionalChildren,
    this.disabled = false,
  });

  final String? taskName;
  final String? description;
  final String? projectName;
  final List<Widget>? additionalChildren;
  final bool disabled;

  final Widget Function(
      BuildContext context, FormGroup form, Widget formListView) builder;

  FormGroup get _formGroup => fb.group(
        {
          taskControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
            disabled: disabled,
            value: taskName,
          ),
          projectControlName: FormControl<String>(
            value: projectName,
            disabled: disabled,
          ),
          descriptionControlName: FormControl<String>(
            value: description,
            disabled: disabled,
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
            if (disabled) ...[
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.all(kPadding.h * 2),
                  child: Text(
                    'This task is already synced with the server. You cannot edit it.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: kPadding.h * 3,
              ),
            ],
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
            if (additionalChildren != null) ...additionalChildren!,
          ],
        );

        return builder(context, formGroup, formListView);
      });
}

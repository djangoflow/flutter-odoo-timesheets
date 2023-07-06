import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

@RoutePage()
class TaskAddPage extends StatelessWidget {
  const TaskAddPage({super.key});

  FormGroup get _formGroup => fb.group(
        {
          'name': FormControl<String>(
            value: '',
            validators: [
              Validators.required,
            ],
          ),
          'description': FormControl<String>(
            value: '',
            validators: [
              Validators.required,
            ],
          ),
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: ScrollableColumn(
        children: [],
      ),
    );
  }
}

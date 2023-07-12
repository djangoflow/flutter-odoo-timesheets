import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/task/task.dart';

import '../task_editor.dart';

@RoutePage()
class TaskAddPage extends StatelessWidget {
  const TaskAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add local task'),
      ),
      body: TaskEditor(
        builder: (context, formGroup, formListView) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(kPadding.w * 2),
              child: const Text('Create task locally.'),
            ),
            Expanded(
              child: formListView,
            ),
            SizedBox(
              width: double.infinity,
              child: SafeArea(
                bottom: true,
                child: LinearProgressBuilder(
                  action: (_) async {
                    final taskName =
                        formGroup.control(taskControlName).value as String;
                    final projectName =
                        formGroup.control(projectControlName).value as String?;
                    final description = formGroup
                        .control(descriptionControlName)
                        .value as String?;

                    await context.read<TasksRepository>().createTaskWithProject(
                          TasksCompanion(
                            name: Value(taskName),
                            description: Value(description),
                          ),
                          ProjectsCompanion(
                            name: Value(projectName),
                          ),
                        );
                  },
                  onSuccess: () => context.router.pop(true),
                  builder: (context, action, error) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: kPadding.w),
                    child: ElevatedButton(
                      onPressed: ReactiveForm.of(context)?.valid == true
                          ? action
                          : null,
                      child: const Text('Add task'),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        additionalChildren: [
          SizedBox(
            height: kPadding.h * 3,
          ),
          Text(
            'Or',
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: kPadding.h * 3,
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ElevationOverlay.applySurfaceTint(
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceTint,
                  4,
                ),
                foregroundColor: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                context.router.push(OdooTaskAddRoute());
              },
              child: const Text('Add task from Odoo'),
            ),
          )
        ],
      ),
    );
  }
}

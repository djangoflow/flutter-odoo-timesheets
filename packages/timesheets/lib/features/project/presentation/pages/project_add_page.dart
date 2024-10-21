import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage()
class ProjectAddPage extends StatelessWidget {
  const ProjectAddPage({
    super.key,
    this.isInitiallyFavorite,
    this.project,
  });
  final bool? isInitiallyFavorite;
  final ProjectModel? project;

  @override
  Widget build(BuildContext context) => GradientScaffold(
        appBar: AppBar(
          title: const Text('Create Project'),
        ),
        body: ProjectEditor(
          isFavorite: project?.isFavorite ?? isInitiallyFavorite,
          project: project,
          builder: (context, form, formListView) => Column(
            children: [
              Expanded(child: formListView),
              SafeArea(
                bottom: true,
                child: ReactiveFormConsumer(
                  builder: (context, form, child) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kPadding * 2),
                    child: LinearProgressBuilder(
                      onSuccess: () async {
                        final router = context.router;
                        await router.maybePop(true);
                      },
                      action: (_) => _addProject(context: context, form: form),
                      builder: (context, action, state) => ElevatedButton(
                        onPressed: form.valid ? action : null,
                        child: const Center(
                          child: Text(
                            'Create Project',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _addProject(
      {required BuildContext context, required FormGroup form}) async {
    final projectName = form.control(projectControlName).value as String;
    final color = form.control(colorControlName).value as OdooColors;
    final isFavorite = form.control(isFavoriteControlName).value as bool;

    final projectRepository = context.read<ProjectRepository>();

    await projectRepository.create(
      ProjectModel(
        name: projectName,
        color: color.index,
        isFavorite: isFavorite,
        taskCount: 0,
        active: true,
        createDate: DateTime.timestamp(),
        writeDate: DateTime.timestamp(),
        id: DateTime.timestamp().millisecondsSinceEpoch,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage()
class LocalProjectsPage extends StatelessWidget {
  const LocalProjectsPage({super.key});

  @override
  Widget build(BuildContext context) => const ProjectListView(
        key: ValueKey('local_projects_page'),
        projectListFilter: ProjectListFilter(
          isLocal: true,
        ),
      );
}

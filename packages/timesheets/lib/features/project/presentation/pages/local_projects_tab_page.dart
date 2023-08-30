import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage(
  name: 'LocalProjectsTab',
)
class LocalProjectsTabPage extends StatelessWidget {
  const LocalProjectsTabPage({super.key});

  @override
  Widget build(BuildContext context) => ProjectListView(
        key: const ValueKey('local_projects_page'),
        projectListFilter: const ProjectListFilter(
          isLocal: true,
        ),
        emptyBuilder: (context, state) => LocalProjectsPlaceHolder(),
      );
}

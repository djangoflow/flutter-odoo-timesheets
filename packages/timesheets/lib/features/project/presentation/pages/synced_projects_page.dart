import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage()
class SyncedProjectsPage extends StatelessWidget {
  const SyncedProjectsPage({super.key});

  @override
  Widget build(BuildContext context) => const ProjectListView(
        key: ValueKey('synced_projects_page'),
        projectListFilter: ProjectListFilter(
          isLocal: false,
        ),
      );
}

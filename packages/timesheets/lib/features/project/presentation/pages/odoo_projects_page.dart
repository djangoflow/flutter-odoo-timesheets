import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage(
  name: 'OdooProjectsTab',
)
class OdooProjectsTabPage extends StatelessWidget {
  const OdooProjectsTabPage({super.key});

  @override
  Widget build(BuildContext context) => ProjectListView(
        key: const ValueKey('synced_projects_page'),
        projectListFilter: const ProjectListFilter(
          isLocal: false,
        ),
        emptyBuilder: (context, state) => OdooProjectsPlaceHolder(),
      );
}

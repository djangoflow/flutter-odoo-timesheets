import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage(name: 'FavoriteProjectsTab')
class FavoriteProjectsTabPage extends StatelessWidget {
  const FavoriteProjectsTabPage({super.key});

  @override
  Widget build(BuildContext context) => ProjectListView(
        key: const ValueKey('fav_projects_page'),
        projectListFilter: const ProjectListFilter(
          isLocal: true,
        ),
        emptyBuilder: (context, state) => FavoriteProjectsPlaceHolder(),
      );
}

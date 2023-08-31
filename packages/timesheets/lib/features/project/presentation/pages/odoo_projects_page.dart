import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage(
  name: 'OdooProjectsTab',
)
class OdooProjectsTabPage extends StatelessWidget implements AutoRouteWrapper {
  const OdooProjectsTabPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    context.read<OdooProjectListCubit>().load(
          const ProjectListFilter(
            isLocal: false,
          ),
        );
    return this;
  }

  @override
  Widget build(BuildContext context) => ProjectListView<OdooProjectListCubit>(
        key: const ValueKey('synced_projects_page'),
        emptyBuilder: (context, state) => OdooProjectsPlaceHolder(),
      );
}

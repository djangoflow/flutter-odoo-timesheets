import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage(
  name: 'AllProjectsTab',
)
class AllProjectsTabPage extends StatelessWidget implements AutoRouteWrapper {
  const AllProjectsTabPage({super.key});
  @override
  Widget wrappedRoute(BuildContext context) {
    context.read<ProjectListCubit>().load(
          const ProjectListFilter(),
        );
    return this;
  }

  @override
  Widget build(BuildContext context) => ProjectListView<ProjectListCubit>(
        key: const ValueKey('projects_page'),
        emptyBuilder: (context, state) => EmptyProjectsPlaceholder(
          title: state.filter?.search != null ? 'No Projects Found' : null,
          onGetStarted: () async {
            final router = context.router;
            final localProjectListCubit = context.read<ProjectListCubit>();

            final result = await router.push(
              ProjectAddRoute(),
            );
            if (result != null && result is bool && result == true) {
              localProjectListCubit.reload();
            }
          },
        ),
      );
}

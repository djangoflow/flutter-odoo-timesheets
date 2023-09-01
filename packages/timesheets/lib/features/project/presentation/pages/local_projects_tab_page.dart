import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage(
  name: 'LocalProjectsTab',
)
class LocalProjectsTabPage extends StatelessWidget implements AutoRouteWrapper {
  const LocalProjectsTabPage({super.key});
  @override
  Widget wrappedRoute(BuildContext context) {
    context.read<LocalProjectListCubit>().load(
          const ProjectListFilter(
            isLocal: true,
          ),
        );
    return this;
  }

  @override
  Widget build(BuildContext context) => ProjectListView<LocalProjectListCubit>(
        key: const ValueKey('local_projects_page'),
        emptyBuilder: (context, state) => LocalProjectsPlaceHolder(
          onGetStarted: () async {
            final router = context.router;
            final localProjectListCubit = context.read<LocalProjectListCubit>();

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

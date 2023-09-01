import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/utils/utils.dart';

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
        emptyBuilder: (context, state) {
          final isAuthenticated = context
              .watch<AuthCubit>()
              .state
              .connectedBackends
              .getBackendsFilteredByType(BackendTypeEnum.odoo)
              .isNotEmpty;

          return OdooProjectsPlaceHolder(
            message: isAuthenticated
                ? 'Create projects in odoo and re-synchronize the app to get started'
                : 'Syncrhonize with odoo to get started',
            onGetStarted: () async {
              final odooProjectListCubit = context.read<OdooProjectListCubit>();
              if (isAuthenticated) {
                // TODO sync projects
              } else {
                final result = await context.router.push(OdooLoginRoute());
                if (result != null && result is bool && result == true) {
                  odooProjectListCubit.reload();
                }
              }
            },
          );
        },
      );
}

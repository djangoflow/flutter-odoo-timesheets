import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/blocs/project_with_external_data_cubit/project_with_external_data_cubit.dart';
import 'package:timesheets/features/project/blocs/project_with_external_data_cubit/project_retrieve_filter.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/presentation/task_listview.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({super.key, @pathParam required this.projectId});
  final int projectId;

  @override
  Widget build(BuildContext context) =>
      BlocProvider<ProjectWithExternalDataCubit>(
        create: (context) => ProjectWithExternalDataCubit(
          context.read<ProjectRepository>(),
        )..load(
            ProjectRetrieveFilter(
              id: projectId,
            ),
          ),
        child: GradientScaffold(
          appBar: AppBar(
            title: BlocBuilder<ProjectWithExternalDataCubit,
                ProjectWithExternalDataState>(
              builder: (context, state) => Text(
                state.data?.project.name ?? 'Project $projectId',
              ),
            ),
          ),
          body: TaskListView(
            taskListFilter: TaskListFilter(
              projectId: projectId,
            ),
            emptyBuilder: (_, __) => BlocBuilder<ProjectWithExternalDataCubit,
                ProjectWithExternalDataState>(
              builder: (context, state) => state.data?.project == null
                  ? const SizedBox()
                  : state.data?.externalProject != null
                      ? OdooTasksPlaceHolder(
                          onGetStarted: () {
                            // TODO add re-sync tasks for a project
                          },
                        )
                      : LocalTasksPlaceHolder(onGetStarted: () {
                          TimesheetRouter(children: [
                            TimesheetAddRoute(),
                          ]);
                        }),
            ),
          ),
        ),
      );
}

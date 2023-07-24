import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/blocs/project_data_cubit/project_data_cubit.dart';
import 'package:timesheets/features/project/blocs/project_data_cubit/project_retrieve_filter.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/presentation/task_listview.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({super.key, @pathParam required this.projectId});
  final int projectId;

  @override
  Widget build(BuildContext context) => BlocProvider<ProjectDataCubit>(
        create: (context) => ProjectDataCubit(
          context.read<ProjectRepository>(),
        )..load(
            ProjectRetrieveFilter(
              id: projectId,
            ),
          ),
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<ProjectDataCubit, ProjectDataState>(
              builder: (context, state) => Text(
                state.data?.name ?? 'Project $projectId',
              ),
            ),
          ),
          body: TaskListView(
            taskListFilter: TaskListFilter(
              projectId: projectId,
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:timesheets/features/project/blocs/project_list_bloc/project_list_bloc.dart';
import 'package:timesheets/features/project/blocs/project_list_bloc/project_list_filter.dart';

import '../../project.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Title'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ContinuousListViewBlocBuilder<ProjectListBloc, Project,
                  ProjectListFilter>(
                create: (context) => ProjectListBloc(
                  context.read<ProjectRepository>(),
                )..load(),
                emptyBuilder: (context, state) => const Center(
                  child: Text('No data'),
                ),
                errorBuilder: (context, state) => const Center(
                  child: Text('Error'),
                ),
                loadingBuilder: (context, state) => const Center(
                  child: CircularProgressIndicator(),
                ),
                itemBuilder: (context, state, index, item) => ListTile(
                  onTap: () {
                    context.read<ProjectListBloc>().load(
                          const ProjectListFilter(search: 'aahi' //
                              ),
                        );
                  },
                  title: Text(item.name),
                ),
              ),
            ),
            const Expanded(
              child: Text('Hello World'),
            )
          ],
        ),
      );
}

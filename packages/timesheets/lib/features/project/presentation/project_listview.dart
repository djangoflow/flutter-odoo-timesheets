import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/project/project.dart';

class ProjectListView extends StatelessWidget {
  const ProjectListView({super.key, required this.projectListFilter});
  final ProjectListFilter projectListFilter;

  @override
  Widget build(BuildContext context) => ContinuousListViewBlocBuilder<
          ProjectListCubit, Project, ProjectListFilter>(
        create: (context) => ProjectListCubit(context.read<ProjectRepository>())
          ..load(projectListFilter),
        withRefreshIndicator: true,
        emptyBuilder: (context, state) => const Center(
          child: Text('No projects'),
        ),
        loadingBuilder: (context, state) => const Center(
          child: CircularProgressIndicator(),
        ),
        itemBuilder: (context, state, index, item) => ListTile(
          title: Text(item.name ?? ''),
          subtitle: Text('${item.taskCount ?? 0} Tasks'),
          onTap: () {},
        ),
        builder: (context, controller, itemBuilder, itemCount) =>
            ListView.separated(
          padding: EdgeInsets.all(
            kPadding.h * 2,
          ),
          itemBuilder: itemBuilder,
          separatorBuilder: (context, index) => SizedBox(
            height: kPadding.h,
          ),
          itemCount: itemCount,
        ),
      );
}

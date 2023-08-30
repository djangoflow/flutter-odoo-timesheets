import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/utils/utils.dart';

class ProjectListView extends StatelessWidget {
  const ProjectListView({super.key, required this.projectListFilter});
  final ProjectListFilter projectListFilter;

  @override
  Widget build(BuildContext context) => ContinuousListViewBlocBuilder<
          ProjectListCubit, ProjectWithExternalData, ProjectListFilter>(
        create: (context) => ProjectListCubit(context.read<ProjectRepository>())
          ..load(projectListFilter),
        withRefreshIndicator: true,
        // emptyBuilder: (context, state) => const EmptyPlaceholder(
        //   message: 'No projects found',
        // ),
        emptyBuilder: (context, state) => SizedBox(),
        loadingBuilder: (context, state) => const SizedBox(),
        itemBuilder: (context, state, index, projectWithExternalData) {
          final project = projectWithExternalData.project;

          return ListTile(
            leading: ColoredBar(
              color: project.color.toColorFromColorIndex,
            ),
            title: Row(
              children: [
                Text(
                  project.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  width: kPadding.w,
                ),
                if (project.isFavorite == true)
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              ],
            ),
            subtitle: Text('${project.taskCount ?? 0} Tasks'),
            onTap: () {
              context.router.push(ProjectDetailsRoute(projectId: project.id));
            },
          );
        },
        builder: (context, controller, itemBuilder, itemCount) =>
            ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
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

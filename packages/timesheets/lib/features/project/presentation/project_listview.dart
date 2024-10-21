import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_list_bloc/flutter_list_bloc.dart';

import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/utils/utils.dart';

class ProjectListView<T extends ProjectListCubit> extends StatelessWidget {
  const ProjectListView({super.key, required this.emptyBuilder});

  final Widget Function(BuildContext context, ProjectListState state)
      emptyBuilder;

  @override
  Widget build(BuildContext context) =>
      ContinuousListViewBlocBuilder<T, ProjectModel, ProjectListFilter>(
        withRefreshIndicator: false,
        emptyBuilder: emptyBuilder,
        loadingBuilder: (context, state) => const SizedBox(),
        itemBuilder: (context, state, index, project) => AnimateIfVisible(
          key: ValueKey(project.id),
          builder: (context, animation) => FadeTransition(
            opacity: animation,
            child: _ProjectListTile(
              key: ValueKey(project.id),
              project: project,
              onTap: () async {
                final cubit = context.read<T>();
                await context.router
                    .push(ProjectDetailsRoute(projectId: project.id));

                cubit.reload(
                  cubit.state.filter?.copyWith(
                    offset: 0,
                  ),
                );
              },
            ),
          ),
        ),
        builder: (context, controller, itemBuilder, itemCount) =>
            AnimateIfVisibleWrapper(
          controller: controller,
          child: ParticleRefreshIndicator(
            onRefresh: () => context.read<T>().reload(
                  context.read<T>().state.filter?.copyWith(
                        offset: 0,
                      ),
                ),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller,
              padding: const EdgeInsets.all(
                kPadding * 2,
              ),
              itemBuilder: itemBuilder,
              separatorBuilder: (context, index) => const SizedBox(
                height: kPadding,
              ),
              itemCount: itemCount,
            ),
          ),
        ),
      );
}

class _ProjectListTile extends StatelessWidget {
  const _ProjectListTile({super.key, required this.project, this.onTap});
  final ProjectModel project;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        elevation: 0,
        child: ListTile(
          leading: ColoredBar(
            color: project.color.toColorFromColorIndex,
          ),
          title: Row(
            children: [
              Icon(
                project.isFavorite == true
                    ? CupertinoIcons.star_fill
                    : CupertinoIcons.star,
              ),
              const SizedBox(
                width: kPadding,
              ),
              Expanded(
                child: Text(
                  project.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Text('${project.taskCount} Tasks'),
          onTap: onTap,
        ),
      );
}

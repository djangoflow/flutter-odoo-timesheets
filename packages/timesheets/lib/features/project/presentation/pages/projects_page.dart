import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage(
  name: 'ProjectsTabRouter',
)
class ProjectsTabRouterPage extends StatefulWidget implements AutoRouteWrapper {
  const ProjectsTabRouterPage({super.key});

  @override
  State<ProjectsTabRouterPage> createState() => _ProjectsTabRouterPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    final projectRepository = context.read<ProjectRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteProjectListCubit>(
          create: (context) => FavoriteProjectListCubit(projectRepository),
        ),
        BlocProvider<ProjectListCubit>(
          create: (context) => ProjectListCubit(projectRepository),
        ),
      ],
      child: Builder(builder: (context) => this),
    );
  }
}

class _ProjectsTabRouterPageState extends State<ProjectsTabRouterPage> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
        routes: const [
          FavoriteProjectsTab(),
          AllProjectsTab(),
        ],
        builder: (context, child, tabController) => IconButtonTheme(
          data: AppTheme.getFilledIconButtonTheme(Theme.of(context)),
          child: GradientScaffold(
            appBar: AppBar(
              title: _isSearching ? null : const Text('Projects'),
              scrolledUnderElevation: 0,
              actions: [
                AnimatedSearchAction(
                  hintText: 'Search projects...',
                  onChanged: (query) => _onSearchChanged(context, query),
                  onSubmitted: (query) {
                    _onSearchChanged(context, query);
                  },
                  onCollapsed: () {
                    setState(() {
                      _isSearching = false;
                    });
                  },
                  onExpanded: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
                const SizedBox(width: kPadding),
                IconButton(
                  onPressed: () => _addProject(context, tabController.index),
                  icon: const Icon(CupertinoIcons.add),
                ),
                const SizedBox(width: kPadding),
              ],
              bottom: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: 'Favorites'),
                  Tab(text: 'All'),
                ],
              ),
            ),
            body: child,
          ),
        ),
      );

  void _onSearchChanged(BuildContext context, String query) {
    final effectiveQuery = query.isNotEmpty ? query : null;
    final favoriteProjectListCubit = context.read<FavoriteProjectListCubit>();
    final projectListCubit = context.read<ProjectListCubit>();
    if (favoriteProjectListCubit.state.filter?.search != effectiveQuery) {
      favoriteProjectListCubit.load(
        favoriteProjectListCubit.state.filter?.copyWith(
          search: effectiveQuery,
        ),
      );
    }
    if (projectListCubit.state.filter?.search != effectiveQuery) {
      projectListCubit.load(
        projectListCubit.state.filter?.copyWith(
          search: effectiveQuery,
        ),
      );
    }
  }

  Future<void> _addProject(BuildContext context, int tabIndex) async {
    final ProjectListCubit cubit;
    bool wasAdded = false;

    if (tabIndex == 0) {
      cubit = context.read<FavoriteProjectListCubit>();
      final result = await context.router.push(
        ProjectAddRoute(isFavorite: true),
      );
      wasAdded = result == true;
    } else {
      cubit = context.read<ProjectListCubit>();
      final result = await context.router.push(ProjectAddRoute());
      wasAdded = result == true;
    }

    if (wasAdded) {
      cubit.reload();
      DjangoflowAppSnackbar.showInfo('Added successfully');
    }
  }
}

import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage(
  name: 'ProjectsTabRouter',
)
class ProjectsTabRouterPage extends StatelessWidget
    implements AutoRouteWrapper {
  const ProjectsTabRouterPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final projectRepository = InMemoryProjectRepository(
      backend: context.read<InMemoryBackend>(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteProjectListCubit>(
          create: (context) => FavoriteProjectListCubit(
            repository: projectRepository,
          ),
        ),
        BlocProvider<LocalProjectListCubit>(
          create: (context) => LocalProjectListCubit(
            repository: projectRepository,
          ),
        ),
      ],
      child: Builder(builder: (context) => this),
    );
  }

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
        routes: const [
          FavoriteProjectsTab(),
          LocalProjectsTab(),
        ],
        builder: (context, child, tabController) => IconButtonTheme(
          data: AppTheme.getFilledIconButtonTheme(Theme.of(context)),
          child: GradientScaffold(
            appBar: AppBar(
              title: const Text('Projects'),
              scrolledUnderElevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              actions: [
                IconButton(
                  onPressed: () {
                    if (tabController.index == 0) {
                      context.router
                          .push(
                        ProjectAddRoute(
                          isInitiallyFavorite: true,
                        ),
                      )
                          .then((value) {
                        if (value == true) {
                          context.read<FavoriteProjectListCubit>().load();
                          DjangoflowAppSnackbar.showInfo('Added successfully');
                        }
                      });
                    } else if (tabController.index == 1) {
                      context.router.push(
                        ProjectAddRoute(),
                      );
                    }
                  },
                  icon: const Icon(CupertinoIcons.add),
                ),
                SizedBox(
                  width: kPadding.w * 2,
                ),
              ],
              centerTitle: false,
              bottom: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: 'Favorites'),
                  Tab(text: 'Local'),
                ],
              ),
            ),
            body: child,
          ),
        ),
      );
}

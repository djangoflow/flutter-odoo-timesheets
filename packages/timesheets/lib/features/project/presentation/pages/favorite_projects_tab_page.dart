import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/project/project.dart';

@RoutePage(name: 'FavoriteProjectsTab')
class FavoriteProjectsTabPage extends StatelessWidget
    implements AutoRouteWrapper {
  const FavoriteProjectsTabPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    context.read<FavoriteProjectListCubit>().load(
          const ProjectListFilter(
            isFavorite: true,
          ),
        );
    return this;
  }

  @override
  Widget build(BuildContext context) =>
      ProjectListView<FavoriteProjectListCubit>(
        key: const ValueKey('fav_projects_page'),
        emptyBuilder: (context, state) => FavoriteProjectsPlaceHolder(
          onGetStarted: () async {
            final router = context.router;
            final favoriteProjectListCubit =
                context.read<FavoriteProjectListCubit>();

            final result = await router.push(
              ProjectAddRoute(
                isInitiallyFavorite: true,
              ),
            );
            if (result != null && result is bool && result == true) {
              favoriteProjectListCubit.reload();
            }
          },
        ),
      );
}

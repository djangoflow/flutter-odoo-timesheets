import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class ProjectDetailsPage extends StatefulWidget implements AutoRouteWrapper {
  const ProjectDetailsPage({super.key, @pathParam required this.projectId});
  final int projectId;

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<ProjectDataCubit>(
            create: (context) => ProjectDataCubit(
              context.read<ProjectRepository>(),
            )..load(
                ProjectRetrieveFilter(
                  id: projectId,
                ),
              ),
          ),
          BlocProvider(
            create: (context) => TaskRelationalListCubit(
                context.read<TaskRelationalRepository>())
              ..load(
                TaskListFilter(
                  projectId: projectId,
                ),
              ),
          ),
        ],
        child: this,
      );
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProjectDataCubit, ProjectDataState>(
        builder: (context, state) => GradientScaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !_isSearching,
            title: _isSearching
                ? null
                : Text(
                    state.data?.name ?? 'Project ${widget.projectId}',
                  ),
            actions: [
              if (state is! Loading && state.data != null) ...[
                AnimatedSearchAction(
                  hintText: 'Search tasks...',
                  widthToNegate: (kPadding.h * 5 * 2) + (kPadding.w / 2),
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
                _OptionsIconButton(
                  state: state,
                ),
              ],
            ],
          ),
          body: TaskListView(
            emptyBuilder: (_, taskState) => EmptyTasksPlaceHolder(
              title: taskState.filter?.search != null ? 'No Tasks Found' : null,
              onGetStarted: () {
                context.pushRoute(TimesheetRouter(
                  children: [
                    TimesheetAddRoute(),
                  ],
                ));
              },
            ),
          ),
        ),
      );

  void _onSearchChanged(BuildContext context, String query) {
    final effectiveQuery = query.isNotEmpty ? query : null;
    final taskListCubit = context.read<TaskRelationalListCubit>();

    if (taskListCubit.state.filter?.search != effectiveQuery) {
      taskListCubit.load(
        taskListCubit.state.filter?.copyWith(
          search: effectiveQuery,
        ),
      );
    }
  }
}

class _OptionsIconButton extends StatelessWidget {
  const _OptionsIconButton({super.key, required this.state});

  final ProjectDataState state;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () async {
          final router = context.router;
          final projectDataCubit = context.read<ProjectDataCubit>();
          final result = await AppModalSheet.show<Options>(
            context: context,
            child: OptionSelector(
              options: [
                Options.delete,
                if (state.data?.isFavorite == true)
                  Options.unFavorite
                else
                  Options.favorite,
              ],
            ),
          );
          if (result != null) {
            switch (result) {
              case Options.delete:
                if (context.mounted) {
                  final result = await AppDialog.showConfirmationDialog(
                    context: context,
                    titleText: 'Delete Project',
                    contentText: 'Are you sure you want to delete '
                        'this project?',
                  );
                  if (result == true) {
                    await projectDataCubit.deleteItem(state.data!.id);
                    router.maybePop(true);
                  }
                }

                break;
              case Options.favorite:
                await projectDataCubit.updateItem(
                  state.data!.copyWith(
                    isFavorite: true,
                  ),
                );

                break;
              case Options.unFavorite:
                await projectDataCubit.updateItem(
                  state.data!.copyWith(
                    isFavorite: false,
                  ),
                );
                break;
              default:
                break;
            }
          }
        },
        icon: const Icon(Icons.more_horiz),
      );
}

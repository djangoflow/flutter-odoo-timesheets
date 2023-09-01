import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/presentation/option_selector.dart';
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
        child: BlocBuilder<ProjectWithExternalDataCubit,
            ProjectWithExternalDataState>(
          builder: (context, state) => GradientScaffold(
            appBar: AppBar(
              title: Text(
                state.data?.project.name ?? 'Project $projectId',
              ),
              actions: [
                if (state is! Loading && state.data?.externalProject == null)
                  IconButton(
                    onPressed: () async {
                      final router = context.router;
                      final projectWithExternalDataCubit =
                          context.read<ProjectWithExternalDataCubit>();
                      final result = await AppModalSheet.show<Options>(
                        context: context,
                        child: OptionSelector(
                          options: [
                            Options.delete,
                            if (state.data?.project.isFavorite == true)
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
                              final result =
                                  await AppDialog.showConfirmationDialog(
                                context: context,
                                titleText: 'Delete Project',
                                contentText: 'Are you sure you want to delete '
                                    'this project?',
                              );
                              if (result == true) {
                                await projectWithExternalDataCubit
                                    .deleteProject();
                                router.pop(true);
                              }
                            }

                            break;
                          case Options.favorite:
                            await projectWithExternalDataCubit.updateProject(
                              state.data!.project.copyWith(
                                isFavorite: const Value(true),
                              ),
                            );
                            break;
                          case Options.unFavorite:
                            await projectWithExternalDataCubit.updateProject(
                              state.data!.project.copyWith(
                                isFavorite: const Value(false),
                              ),
                            );
                            break;
                          default:
                            break;
                        }
                      }
                    },
                    icon: const Icon(Icons.more_horiz),
                  ),
              ],
            ),
            body: TaskListView(
              taskListFilter: TaskListFilter(
                projectId: projectId,
              ),
              emptyBuilder: (_, __) => state.data?.project == null
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

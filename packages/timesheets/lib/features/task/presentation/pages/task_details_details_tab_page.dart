import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage(
  name: 'TaskDetailsDetailsTab',
)
class TaskDetailsDetailsTabPage extends StatelessWidget {
  const TaskDetailsDetailsTabPage({super.key});

  @override
  Widget build(BuildContext context) =>
      SyncProvider<ProjectModel, ProjectRepository>(
          odooModelName: ProjectModel.odooModelName,
          builder: (context, backendId) =>
              SyncProvider<TaskModel, TaskRelationalRepository>(
                odooModelName: TaskModel.odooModelName,
                builder: (context, backendId) =>
                    BlocBuilder<TaskRelationalDataCubit, TaskDataState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const ParticleLoadingIndicator();
                    } else {
                      final project = state.data?.project;
                      final task = state.data;
                      if (backendId != null && state.data != null) {
                        context
                            .read<SyncCubit<TaskModel>>()
                            .loadPendingSyncRegistries(
                          ids: [state.data!.id],
                        );
                        if (state.data?.projectId != null) {
                          context
                              .read<SyncCubit<ProjectModel>>()
                              .loadPendingSyncRegistries(
                            ids: [state.data!.projectId],
                          );
                        }
                      }

                      return ListView(
                        padding: EdgeInsets.all(kPadding * 2),
                        children: [
                          if (project != null && task != null)
                            Padding(
                              padding: EdgeInsets.only(bottom: kPadding),
                              child: _TaskDetailsCard(
                                project: project,
                                task: task,
                                hasBackendId: backendId != null,
                              ),
                            ),
                          if (task?.description != null &&
                              task!.description!.isNotEmpty)
                            _DescriptionCard(
                              description: task.description!,
                            ),
                        ],
                      );
                    }
                  },
                ),
              ));
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.description});
  final String description;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(kPadding * 2),
          child: _TaskDetailsItem(
            title: 'Description',
            child: HtmlWidget(
              description,
              textStyle: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      );
}

class _TaskDetailsCard extends StatelessWidget {
  const _TaskDetailsCard({
    required this.project,
    required this.task,
    required this.hasBackendId,
  });
  final ProjectModel project;
  final TaskModel task;
  final bool hasBackendId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(kPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TaskDetailsItem(
              title: 'Project',
              child: Row(
                children: [
                  SizedBox(
                    height: kPadding * 3,
                    child: ColoredBar(
                      color: project.color.toColorFromColorIndex,
                    ),
                  ),
                  SizedBox(
                    width: kPadding,
                  ),
                  if (hasBackendId)
                    BlocBuilder<SyncCubit<ProjectModel>, SyncState>(
                      builder: (context, state) => _StorageIcon(
                        isExternal: (state.pendingSyncRecordIds != null &&
                                state.pendingSyncRecordIds!
                                    .contains(project.id))
                            ? false
                            : true,
                      ),
                    ),
                  SizedBox(
                    width: kPadding,
                  ),
                  Flexible(
                    child: Text(
                      project.name,
                      style: textTheme.titleMedium,
                    ),
                  )
                ],
              ),
            ),
            if (task.name.isNotEmpty) ...[
              SizedBox(
                height: kPadding * 2,
              ),
              _TaskDetailsItem(
                title: 'Task',
                child: Row(
                  children: [
                    if (hasBackendId) ...[
                      BlocBuilder<SyncCubit<TaskModel>, SyncState>(
                        builder: (context, state) => _StorageIcon(
                          isExternal: (state.pendingSyncRecordIds != null &&
                                  state.pendingSyncRecordIds!.contains(task.id))
                              ? false
                              : true,
                        ),
                      ),
                      SizedBox(
                        width: kPadding,
                      ),
                    ],
                    Flexible(
                      child: Text(
                        task.name,
                        style: textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              )
            ],
            if (task.dateDeadline != null) ...[
              SizedBox(
                height: kPadding * 2,
              ),
              _TaskDetailsItem(
                title: 'Deadline',
                child: Text(
                  DateFormat('dd/MM/yyyy').format(task.dateDeadline!),
                  style: textTheme.titleMedium,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}

class _TaskDetailsItem extends StatelessWidget {
  const _TaskDetailsItem({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(
            height: kPadding / 2,
          ),
          child,
        ],
      );
}

class _StorageIcon extends StatelessWidget {
  const _StorageIcon({required this.isExternal});
  final bool isExternal;
  @override
  Widget build(BuildContext context) => isExternal
      ? const Icon(
          CupertinoIcons.cloud_fill,
        )
      : const Icon(
          CupertinoIcons.floppy_disk,
        );
}

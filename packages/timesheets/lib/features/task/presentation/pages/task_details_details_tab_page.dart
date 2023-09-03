import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage(
  name: 'TaskDetailsDetailsTab',
)
class TaskDetailsDetailsTabPage extends StatelessWidget {
  const TaskDetailsDetailsTabPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final project = state
                .taskWithProjectExternalData?.projectWithExternalData.project;
            final task =
                state.taskWithProjectExternalData?.taskWithExternalData.task;
            final hasExternalTask = state.taskWithProjectExternalData
                    ?.taskWithExternalData.externalTask !=
                null;
            final hasExternalProject = state.taskWithProjectExternalData
                    ?.projectWithExternalData.externalProject !=
                null;

            return ListView(
              padding: EdgeInsets.all(kPadding.h * 2),
              children: [
                if (project != null && task != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: kPadding.h),
                    child: _TaskDetailsCard(
                      project: project,
                      task: task,
                      hasExternalTask: hasExternalTask,
                      hasExternalProject: hasExternalProject,
                    ),
                  ),
                if (task?.description != null && task!.description!.isNotEmpty)
                  _DescriptionCard(
                    description: task.description!,
                  ),
              ],
            );
          }
        },
      );
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.description});
  final String description;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(kPadding.h * 2),
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
  const _TaskDetailsCard(
      {required this.project,
      required this.task,
      required this.hasExternalProject,
      required this.hasExternalTask});
  final Project project;
  final Task task;
  final bool hasExternalProject;
  final bool hasExternalTask;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(kPadding.h * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TaskDetailsItem(
              title: 'Project',
              child: Row(
                children: [
                  SizedBox(
                    height: kPadding.h * 3,
                    child: ColoredBar(
                      color: project.color.toColorFromColorIndex,
                    ),
                  ),
                  SizedBox(
                    width: kPadding.w,
                  ),
                  _StorageIcon(
                    isExternal: hasExternalProject,
                  ),
                  SizedBox(
                    width: kPadding.w,
                  ),
                  Flexible(
                    child: Text(
                      project.name ?? '',
                      style: textTheme.titleMedium,
                    ),
                  )
                ],
              ),
            ),
            if (task.name != null && task.name!.isNotEmpty) ...[
              SizedBox(
                height: kPadding.h * 2,
              ),
              _TaskDetailsItem(
                title: 'Task',
                child: Row(
                  children: [
                    _StorageIcon(
                      isExternal: hasExternalTask,
                    ),
                    SizedBox(
                      width: kPadding.w,
                    ),
                    Flexible(
                      child: Text(
                        task.name!,
                        style: textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              )
            ],
            if (task.dateDeadline != null) ...[
              SizedBox(
                height: kPadding.h * 2,
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
            height: kPadding.h / 2,
          ),
          child,
        ],
      );
}

class _StorageIcon extends StatelessWidget {
  const _StorageIcon({super.key, required this.isExternal});
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

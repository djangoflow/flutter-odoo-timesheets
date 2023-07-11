import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage()
class TimesheetDetailsPage extends StatelessWidget {
  const TimesheetDetailsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TimesheetDataCubit, TimesheetDataState>(
        builder: (context, state) {
          final timesheetWithTask = state.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                timesheetWithTask != null
                    ? 'Timesheet ${timesheetWithTask.timesheet.id}'
                    : 'Timesheet details',
              ),
              leading: const AutoLeadingButton(),
              actions: [
                if (timesheetWithTask != null)
                  IconButton(
                    onPressed: () {
                      context.router.push(
                        const TimesheetEditRoute(),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  )
              ],
            ),
            body: state.map(
              (value) => value.data == null
                  ? const Center(
                      child: Text(
                        'No data!',
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.all(kPadding.w * 2),
                      children: [
                        _TimesheetDetails(
                          timesheetWithTask: timesheetWithTask!,
                        ),
                      ],
                    ),
              loading: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (_) => const Center(
                child: Text(
                  'Error!',
                ),
              ),
              empty: (value) => const Center(
                child: Text(
                  'No data!',
                ),
              ),
            ),
          );
        },
      );
}

class _TimesheetDetails extends StatelessWidget {
  const _TimesheetDetails({super.key, required this.timesheetWithTask});
  final TimesheetWithTask timesheetWithTask;

  @override
  Widget build(BuildContext context) {
    final task = timesheetWithTask.taskWithProject.task;
    final project = timesheetWithTask.taskWithProject.project;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimesheetItem(
          title: 'Task',
          value: task.name,
        ),
        SizedBox(
          height: kPadding.h * 2,
        ),
        _TimesheetItem(
          title: 'Project',
          value: project.name ?? '',
        ),
        SizedBox(
          height: kPadding.h * 2,
        ),
        _TimesheetItem(
          title: 'Date',
          value: DateFormat('dd/MM/yyyy')
              .format(timesheetWithTask.timesheet.startTime),
        ),
        SizedBox(
          height: kPadding.h * 2,
        ),
        _TimesheetItem(
          title: 'Start time',
          value: DateFormat('HH:mm:ss')
              .format(timesheetWithTask.timesheet.startTime),
        ),
        SizedBox(
          height: kPadding.h * 2,
        ),
        _TimesheetItem(
          title: 'End time',
          value: DateFormat('HH:mm:ss')
              .format(timesheetWithTask.timesheet.endTime),
        ),
      ],
    );
  }
}

class _TimesheetItem extends StatelessWidget {
  const _TimesheetItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(
          height: kPadding.h / 2,
        ),
        Text(
          value,
          style: textTheme.titleMedium,
        ),
      ],
    );
  }
}

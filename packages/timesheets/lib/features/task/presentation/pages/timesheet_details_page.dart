import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class TimesheetDetailsPage extends StatelessWidget {
  const TimesheetDetailsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TimesheetDataCubit, TimesheetDataState>(
        builder: (context, state) {
          final timesheetWithTaskExternalData = state.data;
          final timesheet =
              timesheetWithTaskExternalData?.timesheetExternalData.timesheet;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                timesheet != null
                    ? 'Timesheet ${timesheet.id}'
                    : 'Timesheet details',
              ),
              leading: const AutoLeadingButton(),
              actions: [
                if (timesheet != null)
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
                          timesheetWithTaskExternalData:
                              timesheetWithTaskExternalData!,
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
  const _TimesheetDetails(
      {super.key, required this.timesheetWithTaskExternalData});
  final TimesheetWithTaskExternalData timesheetWithTaskExternalData;

  @override
  Widget build(BuildContext context) {
    final task = timesheetWithTaskExternalData
        .taskWithProjectExternalData.taskWithExternalData.task;
    final project = timesheetWithTaskExternalData
        .taskWithProjectExternalData.projectWithExternalData.project;
    final timesheet =
        timesheetWithTaskExternalData.timesheetExternalData.timesheet;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimesheetItem(
          title: 'Task',
          value: task.name ?? '',
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
          value: timesheet.startTime != null
              ? DateFormat('dd/MM/yyyy').format(timesheet.startTime!)
              : '',
        ),
        SizedBox(
          height: kPadding.h * 2,
        ),
        _TimesheetItem(
          title: 'Start time',
          value: timesheet.startTime != null
              ? DateFormat('HH:mm:ss').format(timesheet.startTime!)
              : '',
        ),
        SizedBox(
          height: kPadding.h * 2,
        ),
        _TimesheetItem(
          title: 'End time',
          value: timesheet.endTime != null
              ? DateFormat('HH:mm:ss').format(timesheet.endTime!)
              : '',
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

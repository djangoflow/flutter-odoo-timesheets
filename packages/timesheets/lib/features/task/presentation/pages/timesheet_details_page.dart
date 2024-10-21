import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage()
class TimesheetDetailsPage extends StatelessWidget {
  const TimesheetDetailsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TimesheetDataCubit, TimesheetDataState>(
        builder: (context, state) {
          final timesheet = state.data;

          return GradientScaffold(
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
                        TimesheetEditRoute(
                          timesheetId: timesheet.id,
                        ),
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
                      padding: const EdgeInsets.all(kPadding * 2),
                      children: [
                        _TimesheetDetails(
                          timesheet: timesheet!,
                        ),
                      ],
                    ),
              loading: (_) => const Center(
                child: ParticleLoadingIndicator(),
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
  const _TimesheetDetails({required this.timesheet});
  final TimesheetModel timesheet;

  @override
  Widget build(BuildContext context) {
    final task = timesheet.task;
    final project = timesheet.project;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimesheetItem(
          title: 'Task',
          value: task?.name ?? '',
        ),
        const SizedBox(
          height: kPadding * 2,
        ),
        _TimesheetItem(
          title: 'Project',
          value: project?.name ?? '',
        ),
        const SizedBox(
          height: kPadding * 2,
        ),
        _TimesheetItem(
          title: 'Date',
          value: DateFormat('dd/MM/yyyy').format(timesheet.createDate),
        ),
        const SizedBox(
          height: kPadding * 2,
        ),
        _TimesheetItem(
          title: 'Start time',
          value: DateFormat('HH:mm:ss').format(timesheet.createDate),
        ),
        const SizedBox(
          height: kPadding * 2,
        ),
        _TimesheetItem(
          title: 'End time',
          value: DateFormat('HH:mm:ss').format(timesheet.createDate),
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
        const SizedBox(
          height: kPadding / 2,
        ),
        Text(
          value,
          style: textTheme.titleMedium,
        ),
      ],
    );
  }
}

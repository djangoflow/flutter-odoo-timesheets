import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage(name: 'TaskDetailsTabRouter')
class TaskDetailsTabRouterPage extends StatelessWidget {
  const TaskDetailsTabRouterPage({super.key});

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
        builder: (context, child, tabController) =>
            BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
          builder: (context, state) => GradientScaffold(
            appBar: AppBar(
              title: Text(
                state.taskWithProject?.task.name ?? '',
              ),
              scrolledUnderElevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              centerTitle: true,
              leading: const AutoLeadingButton(),
              bottom: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Timesheets'),
                  Tab(text: 'Details'),
                ],
              ),
            ),
            body: child,
          ),
        ),
        routes: const [
          TaskDetailsTimesheetsTab(),
          TaskDetailsDetailsTab(),
        ],
      );
}

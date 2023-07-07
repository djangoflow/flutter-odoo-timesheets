import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/presentation/task_list_tile.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';

@RoutePage()
class TasksPage extends StatelessWidget with AutoRouteWrapper {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                size: kPadding.r * 4,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kPadding.r),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          child: Icon(
            Icons.add,
            size: kPadding.r * 4,
          ),
          onPressed: () async {
            final result = await context.router.push(const TaskAddRoute());
            if (result != null && result == true) {
              if (context.mounted) {
                context.read<TasksListCubit>().load(
                      const TasksListFilter(),
                    );
              }
            }
          },
        ),
        body: Padding(
          padding: EdgeInsets.only(top: kPadding.h * 3),
          child: RefreshIndicator(
            onRefresh: () => context.read<TasksListCubit>().load(
                  const TasksListFilter(),
                ),
            child: BlocBuilder<TasksListCubit, TasksListState>(
              builder: (context, state) => state.map(
                (value) => ListView.separated(
                  itemCount: value.data?.length ?? 0,
                  separatorBuilder: (context, index) => SizedBox(
                    height: kPadding.h,
                  ),
                  itemBuilder: (context, index) {
                    final task = value.data![index];
                    final elapsedTime = _calculateElapsedTime(task);

                    return TaskListTile(
                      key: ValueKey(task.id),
                      title: Text(task.name),
                      subtitle: Text(task.description ?? ''),
                      elapsedTime: elapsedTime,
                      initialTimerStatus: TimerStatus.values[task.status],
                      onTap: () {
                        context.router.push(TaskDetailsRoute(taskId: task.id));
                      },
                      onTimerResume: (context) {
                        context.read<TimerCubit>().elapsedTime = Duration(
                          seconds: elapsedTime,
                        );
                      },
                      onTimerStateChange:
                          (timerState, tickDurationInSeconds) async {
                        final isRunning =
                            timerState.status == TimerStatus.running;
                        final updatableSeconds =
                            (isRunning ? tickDurationInSeconds : 0);
                        final lastTickedValue =
                            isRunning ? DateTime.now() : task.lastTicked;

                        if (isRunning && task.firstTicked == null) {
                          task.copyWith(
                            firstTicked: Value(DateTime.now()),
                          );
                        }

                        await context.read<TasksListCubit>().updateTask(
                              task.copyWith(
                                duration: elapsedTime + updatableSeconds,
                                status: timerState.status.index,
                                lastTicked: Value(lastTickedValue),
                              ),
                            );
                      },
                    );
                  },
                ),
                loading: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
                empty: (_) => const TasksPlaceHolder(),
                error: (_) => const Center(
                  child: Text('Error occurred!'),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<TasksListCubit>(
        create: (context) => TasksListCubit(
          context.read<TasksRepository>(),
        )..load(
            const TasksListFilter(),
          ),
        child: this,
      );
  int _calculateElapsedTime(Task task) {
    final elapsedTime = Duration(seconds: task.duration) +
        ([TimerStatus.running.index, TimerStatus.pausedByForce.index]
                    .contains(task.status) &&
                task.lastTicked != null
            ? DateTime.now().difference(task.lastTicked!)
            : Duration.zero);
    return elapsedTime.inSeconds;
  }
}

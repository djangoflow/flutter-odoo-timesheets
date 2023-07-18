import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/presentation/task_list_tile.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';
import 'package:timesheets/utils/utils.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage()
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with AutoRouteAwareStateMixin<TasksPage> {
  ValueNotifier<bool>? _isPageVisible;
  final mainKey = const ValueKey('tasks_list_visiblity_detector');

  @override
  void didPopNext() {
    context.read<TasksListCubit>().load(
          const TasksListFilter(),
        );
  }

  @override
  void initState() {
    super.initState();
    _isPageVisible = ValueNotifier<bool>(true);
    VisibilityDetectorController.instance.updateInterval =
        animationDurationShort;
  }

  @override
  void dispose() {
    _isPageVisible?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: mainKey,
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 0) {
            _isPageVisible?.value = false;
          } else {
            _isPageVisible?.value = true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tasks'),
            actions: [
              IconButton(
                onPressed: () {
                  context.router.push(const SettingsRoute());
                },
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
              context.router.push(const TaskAddRoute());
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
                  (value) => _isPageVisible == null
                      ? const SizedBox()
                      : ValueListenableBuilder<bool>(
                          valueListenable: _isPageVisible!,
                          builder: (context, isVisible, child) => !isVisible
                              ? const SizedBox()
                              : ListView.separated(
                                  itemCount: value.data?.length ?? 0,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: kPadding.h,
                                  ),
                                  itemBuilder: (context, index) {
                                    final taskWithProjectExternalData =
                                        value.data![index];
                                    final task =
                                        taskWithProjectExternalData.task;
                                    final elapsedTime = task.elapsedTime;

                                    return TaskListTile(
                                      key: ValueKey(task.id),
                                      title: Text(task.name),
                                      subtitle: Text(
                                        task.description ?? '',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      elapsedTime: elapsedTime,
                                      initialTimerStatus:
                                          TimerStatus.values[task.status],
                                      onTap: () {
                                        context.router.push(
                                          TaskDetailsRouter(
                                            taskId: task.id,
                                            children: const [
                                              TaskDetailsRoute()
                                            ],
                                          ),
                                        );
                                      },
                                      onTimerResume: (context) {
                                        context.read<TimerCubit>().elapsedTime =
                                            Duration(
                                          seconds: elapsedTime,
                                        );
                                      },
                                      onTimerStateChange: (timerState,
                                          tickDurationInSeconds) async {
                                        final isRunning = timerState.status ==
                                            TimerStatus.running;
                                        final updatableSeconds = (isRunning
                                            ? tickDurationInSeconds
                                            : 0);
                                        final lastTickedValue = isRunning
                                            ? DateTime.now()
                                            : task.lastTicked;

                                        if (isRunning &&
                                            task.firstTicked == null) {
                                          task.copyWith(
                                            firstTicked: Value(DateTime.now()),
                                          );
                                        }

                                        await context
                                            .read<TasksListCubit>()
                                            .updateTask(
                                              task.copyWith(
                                                duration: elapsedTime +
                                                    updatableSeconds,
                                                status: timerState.status.index,
                                                lastTicked:
                                                    Value(lastTickedValue),
                                              ),
                                            );
                                      },
                                    );
                                  },
                                ),
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
        ),
      );
}

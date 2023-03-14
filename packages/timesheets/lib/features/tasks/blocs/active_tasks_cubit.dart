import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/tasks/data/models/active_task_model.dart';

part 'tasks_cubit.freezed.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState({
    required List<ActiveTask> activeTasks,
  }) = _TaskState;

  factory TaskState.fromJson(Map<String, dynamic> json) =>
      _$TaskStateFromJson(json);
}

class TaskCubit extends HydratedCubit<TaskState> {
  TaskCubit()
      : super(
          const TaskState(activeTasks: []),
        );

  @override
  TaskState? fromJson(Map<String, dynamic> json) => TaskState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(TaskState state) => state.toJson();
}

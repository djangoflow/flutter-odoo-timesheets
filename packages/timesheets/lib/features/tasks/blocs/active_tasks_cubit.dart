import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/tasks/data/models/active_task_model.dart';

part 'active_tasks_cubit.freezed.dart';
part 'active_tasks_cubit.g.dart';

@freezed
class ActiveTaskState with _$ActiveTaskState {
  const factory ActiveTaskState({
    required List<ActiveTask> activeTasks,
  }) = _ActiveTaskState;

  factory ActiveTaskState.fromJson(Map<String, dynamic> json) =>
      _$ActiveTaskStateFromJson(json);
}

class ActiveTaskCubit extends HydratedCubit<ActiveTaskState> {
  ActiveTaskCubit()
      : super(
          const ActiveTaskState(activeTasks: []),
        );

  @override
  ActiveTaskState? fromJson(Map<String, dynamic> json) => ActiveTaskState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ActiveTaskState state) => state.toJson();
}

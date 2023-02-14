part of 'task_cubit.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState.initial() = _Initial;

  const factory TaskState.loading() = _Loading;

  const factory TaskState.error(
      [@Default('Unable to load projects') String message]) = _Error;

  const factory TaskState.success(
    List<Task> tasks,
  ) = _Success;

  factory TaskState.fromJson(Map<String, dynamic> json) =>
      _$TaskStateFromJson(json);
}

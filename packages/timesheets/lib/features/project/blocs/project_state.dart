part of 'project_cubit.dart';

@freezed
class ProjectState with _$ProjectState {
  const factory ProjectState.initial() = _Initial;

  const factory ProjectState.loading() = _Loading;

  const factory ProjectState.error(
      [@Default('Unable to load projects') String message]) = _Error;

  const factory ProjectState.success(
    List<Project> projects,
  ) = _Success;

  factory ProjectState.fromJson(Map<String, dynamic> json) =>
      _$ProjectStateFromJson(json);
}

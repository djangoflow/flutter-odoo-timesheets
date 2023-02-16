import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/tasks/tasks.dart';

part 'activity_cubit.freezed.dart';

part 'activity_cubit.g.dart';

class ActivityCubit extends HydratedCubit<ActivityState> {
  ActivityCubit(this._activityRepository) : super(const ActivityState());

  final ActivityRepository _activityRepository;

  void logActivity({
    required DateTime startDate,
    required Project project,
    required Task task,
    required String description,
  }) {
    emit(state.copyWith(
      startTime: startDate,
      project: project,
      task: task,
      description: description,
      activityStatus: ActivityStatus.ongoing,
    ));
  }

  void syncActivity(
      {required int id,
      required String password,
      required Activity activity}) async {

    emit(state.copyWith(activityStatus: ActivityStatus.syncing));

    print(activity.toJson());
    await _activityRepository.addTimesheetEntry(
      id: id,
      password: password,
      data: activity.toJson(),
    );

    emit(
      state.copyWith(
        startTime: null,
        project: null,
        activityStatus: ActivityStatus.initial,
        description: null,
        task: null
      ),
    );
  }

  @override
  ActivityState? fromJson(Map<String, dynamic> json) =>
      ActivityState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ActivityState state) => state.toJson();
}

@freezed
class ActivityState with _$ActivityState {
  const factory ActivityState({
    DateTime? startTime,
    Project? project,
    Task? task,
    String? description,
    @Default(ActivityStatus.initial) ActivityStatus activityStatus,
  }) = _ActivityState;

  factory ActivityState.fromJson(Map<String, dynamic> json) =>
      _$ActivityStateFromJson(json);
}

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'last_auto_sync_state.dart';

class LastAutoSyncCubit extends HydratedCubit<LastAutoSyncState> {
  LastAutoSyncCubit() : super(const LastAutoSyncState());

  void updateLastAutoSync(String databaseName) {
    emit(state.copyWith(
      lastAutoSyncTimes: {
        ...state.lastAutoSyncTimes,
        databaseName: DateTime.now(),
      },
    ));
  }

  DateTime? getLastAutoSyncTime(String databaseName) =>
      state.lastAutoSyncTimes[databaseName];

  bool isFirstAutoSync(String databaseName) =>
      !state.lastAutoSyncTimes.containsKey(databaseName);

  @override
  LastAutoSyncState? fromJson(Map<String, dynamic> json) =>
      LastAutoSyncState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(LastAutoSyncState state) => state.toJson();
}

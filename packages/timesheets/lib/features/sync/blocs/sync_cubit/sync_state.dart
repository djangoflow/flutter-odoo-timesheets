import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_state.freezed.dart';

@freezed
class SyncState with _$SyncState {
  const factory SyncState({
    required SyncStatus status,
    List<int>? pendingSyncRecordIds,
    @Default(false) bool isBackgroundSync,
  }) = _SyncState;
}

enum SyncStatus {
  syncInitial,
  syncInProgress,
  syncSuccess,
  syncFailure,
}

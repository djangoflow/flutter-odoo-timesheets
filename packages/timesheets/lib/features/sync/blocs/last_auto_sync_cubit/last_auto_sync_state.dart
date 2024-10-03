import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_auto_sync_state.freezed.dart';
part 'last_auto_sync_state.g.dart';

@freezed
class LastAutoSyncState with _$LastAutoSyncState {
  const factory LastAutoSyncState({
    @Default({}) Map<String, DateTime?> lastAutoSyncTimes,
  }) = _LastAutoSyncState;

  factory LastAutoSyncState.fromJson(Map<String, dynamic> json) =>
      _$LastAutoSyncStateFromJson(json);
}

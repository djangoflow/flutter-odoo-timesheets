import 'package:freezed_annotation/freezed_annotation.dart';

// freezed class with isSycning, success and failure, intial

part 'sync_state.freezed.dart';

@freezed
class SyncState with _$SyncState {
  const SyncState._();
  const factory SyncState.initial() = _Initial;
  const factory SyncState.syncing() = _Syncing;
  const factory SyncState.success() = _Success;
  const factory SyncState.failure() = _Failure;

  bool get isInitial => this is _Initial;
  bool get isSyncing => this is _Syncing;
  bool get isSuccess => this is _Success;
  bool get isFailure => this is _Failure;
}

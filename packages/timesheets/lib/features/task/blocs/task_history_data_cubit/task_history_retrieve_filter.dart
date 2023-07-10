import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_history_retrieve_filter.freezed.dart';

@freezed
class TaskHistoryRetrieveFilter with _$TaskHistoryRetrieveFilter {
  const factory TaskHistoryRetrieveFilter({
    required int taskHistoryId,
  }) = _TaskHistoryRetrieveFilter;
}

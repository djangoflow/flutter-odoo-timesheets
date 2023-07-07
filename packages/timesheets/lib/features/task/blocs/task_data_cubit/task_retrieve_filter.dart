import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_retrieve_filter.freezed.dart';

@freezed
class TaskRetrieveFilter with _$TaskRetrieveFilter {
  const factory TaskRetrieveFilter({
    required int taskId,
  }) = _TaskRetrieveFilter;
}

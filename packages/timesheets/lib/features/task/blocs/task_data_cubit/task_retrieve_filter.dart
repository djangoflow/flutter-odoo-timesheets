import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_retrieve_filter.freezed.dart';
part 'task_retrieve_filter.g.dart';

@freezed
class TaskRetrieveFilter with _$TaskRetrieveFilter {
  const factory TaskRetrieveFilter({
    required int id,
  }) = _TaskRetrieveFilter;

  factory TaskRetrieveFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TaskRetrieveFilterFromJson(map);
}

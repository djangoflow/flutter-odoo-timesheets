import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:timesheets/features/app/app.dart';

part 'task_data_filter.freezed.dart';
part 'task_data_filter.g.dart';

@freezed
class TaskDataFilter with _$TaskDataFilter implements ByIdFilter<int> {
  const TaskDataFilter._();

  @Implements<ByIdFilter<int>>()
  const factory TaskDataFilter({
    required int id,
  }) = _TaskDataFilter;

  factory TaskDataFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TaskDataFilterFromJson(map);

  @override
  copyWithId(int id) => copyWith(id: id);
}

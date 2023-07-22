import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';

part 'tasks_list_filter.freezed.dart';
part 'tasks_list_filter.g.dart';

@freezed
class TaskListFilter with _$TaskListFilter implements OffsetLimitFilter {
  static const kPageSize = 50;
  const TaskListFilter._();

  @Implements<OffsetLimitFilter>()
  const factory TaskListFilter({
    @Default(50) int limit,
    @Default(0) int offset,
    int? projectId,
    String? search,
  }) = _TaskListFilter;

  factory TaskListFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TaskListFilterFromJson(map);

  @override
  TaskListFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

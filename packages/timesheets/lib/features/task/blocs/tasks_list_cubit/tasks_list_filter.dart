import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';

part 'tasks_list_filter.freezed.dart';
part 'tasks_list_filter.g.dart';

@freezed
class TasksListFilter with _$TasksListFilter implements OffsetLimitFilter {
  static const kPageSize = 25;
  const TasksListFilter._();

  @Implements<OffsetLimitFilter>()
  const factory TasksListFilter({
    @Default(25) int limit,
    @Default(0) int offset,
  }) = _TasksListFilter;

  factory TasksListFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TasksListFilterFromJson(map);

  @override
  TasksListFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

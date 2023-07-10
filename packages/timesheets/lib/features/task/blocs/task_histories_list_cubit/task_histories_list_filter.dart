import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';

part 'task_histories_list_filter.freezed.dart';
part 'task_histories_list_filter.g.dart';

@freezed
class TaskHistoriesListFilter with _$TaskHistoriesListFilter {
  const factory TaskHistoriesListFilter({
    int? taskId,
  }) = _TaskHistoriesListFilter;

  factory TaskHistoriesListFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$TaskHistoriesListFilterFromJson(map);
}

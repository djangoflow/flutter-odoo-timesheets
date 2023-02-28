import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';

part 'project_list_filter.freezed.dart';
part 'project_list_filter.g.dart';

@freezed
class ProjectListFilter with _$ProjectListFilter implements OffsetLimitFilter {
  const ProjectListFilter._();
  static const kPageSize = 25;
  @Implements<OffsetLimitFilter>()
  const factory ProjectListFilter({
    @Default(25) int limit,
    @Default(0) int offset,
    String? search,
  }) = _ProjectListFilter;

  factory ProjectListFilter.fromJson(
      Map<String, dynamic> map,
      ) =>
      _$ProjectListFilterFromJson(map);

  @override
  ProjectListFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

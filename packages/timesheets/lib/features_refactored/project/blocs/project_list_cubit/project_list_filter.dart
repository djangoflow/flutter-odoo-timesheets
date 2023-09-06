import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';

part 'project_list_filter.freezed.dart';
part 'project_list_filter.g.dart';

@freezed
class ProjectListFilter with _$ProjectListFilter implements OffsetLimitFilter {
  const ProjectListFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory ProjectListFilter({
    @Default(50) int limit,
    @Default(0) int offset,
    String? search,
    bool? isFavorite,
  }) = _ProjectListFilter;

  factory ProjectListFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$ProjectListFilterFromJson(map);

  @override
  ProjectListFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

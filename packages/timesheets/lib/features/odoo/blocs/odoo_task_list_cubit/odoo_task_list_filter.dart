import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';

part 'odoo_task_list_filter.freezed.dart';
part 'odoo_task_list_filter.g.dart';

@freezed
class OdooTaskListFilter
    with _$OdooTaskListFilter
    implements OffsetLimitFilter {
  const OdooTaskListFilter._();

  static const kPageSize = 50;

  @Implements<OffsetLimitFilter>()
  const factory OdooTaskListFilter({
    @Default(25) int limit,
    @Default(0) int offset,
    required int projectId,
    String? search,
  }) = _OdooTaskListFilter;

  factory OdooTaskListFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$OdooTaskListFilterFromJson(map);

  @override
  OdooTaskListFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

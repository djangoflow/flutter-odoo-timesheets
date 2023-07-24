import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:list_bloc/list_bloc.dart';

part 'odoo_project_list_filter.freezed.dart';
part 'odoo_project_list_filter.g.dart';

@freezed
class OdooProjectListFilter
    with _$OdooProjectListFilter
    implements OffsetLimitFilter {
  const OdooProjectListFilter._();
  static const kPageSize = 50;
  @Implements<OffsetLimitFilter>()
  const factory OdooProjectListFilter({
    @Default(25) int limit,
    @Default(0) int offset,
    String? search,
  }) = _OdooProjectListFilter;

  factory OdooProjectListFilter.fromJson(
    Map<String, dynamic> map,
  ) =>
      _$OdooProjectListFilterFromJson(map);

  @override
  OdooProjectListFilter copyWithOffset(int offset) => copyWith(offset: offset);
}

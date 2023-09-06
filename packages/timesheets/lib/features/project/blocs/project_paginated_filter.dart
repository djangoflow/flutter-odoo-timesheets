import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';

part 'project_paginated_filter.g.dart';

@CopyWith()
@JsonSerializable()
class ProjectPaginatedFilter implements OffsetLimitFilter {
  static const kPageSize = defaultLimit;
  ProjectPaginatedFilter({required this.limit, required this.offset});

  @override
  copyWithOffset(int offset) =>
      ProjectPaginatedFilter(limit: limit, offset: offset);

  @override
  final int limit;

  @override
  final int offset;

  factory ProjectPaginatedFilter.fromJson(Map<String, dynamic> json) =>
      _$ProjectPaginatedFilterFromJson(json);
}

import 'package:timesheets/features/app/blocs/crud_list_cubit/crud_list_cubit.dart';
import 'package:timesheets/features/project/blocs/project_paginated_filter.dart';
import 'package:timesheets/features/project/data/models/project.dart';

class ProjectListCubit extends CrudListCubit<Project, ProjectPaginatedFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  ProjectListCubit({required super.repository});
}

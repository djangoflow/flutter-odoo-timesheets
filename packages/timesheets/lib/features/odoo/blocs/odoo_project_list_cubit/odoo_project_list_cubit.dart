import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/odoo/data/models/odoo_project.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_project_repository.dart';

import 'odoo_project_list_filter.dart';

export 'odoo_project_list_filter.dart';

class ProjectListCubit extends ListCubit<OdooProject, OdooProjectListFilter> {
  ProjectListCubit(OdooProjectRepository projectRepository)
      : super(projectRepository.getProjects);
}

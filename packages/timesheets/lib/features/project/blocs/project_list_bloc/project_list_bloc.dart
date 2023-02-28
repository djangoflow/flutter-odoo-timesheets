import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/project/blocs/project_list_bloc/project_list_filter.dart';
import 'package:timesheets/features/project/project.dart';

class ProjectListBloc extends ListCubit<Project, ProjectListFilter> {
  final ProjectRepository _projectRepository;
  ProjectListBloc(this._projectRepository)
      : super(_projectRepository.getProjects);
}

import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/project/project.dart';

class ProjectListCubit extends ListCubit<Project, ProjectListFilter> {
  final ProjectRepository _projectRepository;
  ProjectListCubit(this._projectRepository)
      : super(_projectRepository.getProjects);
}

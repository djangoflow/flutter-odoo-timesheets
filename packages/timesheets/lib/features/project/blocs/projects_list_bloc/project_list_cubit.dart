import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/project/project.dart';

class ProjectListCubit extends ListCubit<Project, ProjectListFilter> {
  ProjectListCubit(ProjectRepository projectRepository)
      : super(projectRepository.getProjects);
}

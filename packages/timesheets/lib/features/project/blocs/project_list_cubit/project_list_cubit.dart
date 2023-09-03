import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/utils/utils.dart';

typedef ProjectListState
    = Data<List<ProjectWithExternalData>, ProjectListFilter>;

class ProjectListCubit
    extends ListCubit<ProjectWithExternalData, ProjectListFilter> {
  final ProjectRepository projectRepository;
  ProjectListCubit(this.projectRepository)
      : super(
          ListBlocUtil.listLoader<ProjectWithExternalData, ProjectListFilter>(
            loader: ([filter]) =>
                projectRepository.getPaginatedProjectsWithExternalData(
              limit: filter?.limit,
              offset: filter?.offset,
              isLocal: filter?.isLocal,
              search: filter?.search,
              isFavorite: filter?.isFavorite,
            ),
          ),
        );

  Future<Project?> createProject(ProjectsCompanion projectsCompanion) async {
    final timesheetId = await projectRepository.create(projectsCompanion);
    return await projectRepository.getItemById(timesheetId);
  }
}

class FavoriteProjectListCubit extends ProjectListCubit {
  FavoriteProjectListCubit(super.projectRepository);
}

class LocalProjectListCubit extends ProjectListCubit {
  LocalProjectListCubit(super.projectRepository);
}

class OdooProjectListCubit extends ProjectListCubit {
  OdooProjectListCubit(super.projectRepository);
}

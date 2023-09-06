import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features_refactored/project/data/entities/project_entity.dart';
import 'package:timesheets/features_refactored/project/data/repositories/project_repository.dart';
import 'package:timesheets/utils/utils.dart';

import 'project_list_filter.dart';
export 'project_list_filter.dart';

typedef ProjectListState = Data<List<ProjectEntity>, ProjectListFilter>;

class ProjectListCubit extends ListCubit<ProjectEntity, ProjectListFilter> {
  final ProjectRepository projectRepository;
  ProjectListCubit(this.projectRepository)
      : super(
          ListBlocUtil.listLoader<ProjectEntity, ProjectListFilter>(
            loader: ([filter]) => projectRepository.getPaginatedItems(
              limit: filter?.limit,
              offset: filter?.offset,
              search: filter?.search,
              isFavorite: filter?.isFavorite,
            ),
          ),
        );

  Future<ProjectEntity?> createProject(ProjectEntity projectEntity) async {
    final timesheetId = await projectRepository.insert(projectEntity);
    return await projectRepository.getById(timesheetId);
  }
}

class FavoriteProjectListCubit extends ProjectListCubit {
  FavoriteProjectListCubit(super.projectRepository);
}

class LocalProjectListCubit extends ProjectListCubit {
  LocalProjectListCubit(super.projectRepository);
}

import 'package:list_bloc/list_bloc.dart';

import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/utils/utils.dart';

typedef ProjectListState = Data<List<ProjectModel>, ProjectListFilter>;

class ProjectListCubit
    extends SyncableListCubit<ProjectModel, ProjectListFilter> {
  final ProjectRepository projectRepository;
  ProjectListCubit(this.projectRepository,
      {Future<List<ProjectModel>> Function([ProjectListFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.listLoader<ProjectModel, ProjectListFilter>(
                loader: ([filter]) => projectRepository.getAll(
                  offset: filter?.offset,
                  limit: filter?.limit,
                  isFavorite: filter?.isFavorite,
                  search: filter?.search,
                  returnOnlySecondary: true,
                  showMarkedAsDeleted: false,
                ),
              ),
          projectRepository,
        );

  @override
  Future<ProjectModel> updateItem(ProjectModel model,
      {bool shouldUpdateSecondaryOnly = false}) async {
    final result = await (repository as ProjectRepository).update(
        model.copyWith(
          writeDate: DateTime.timestamp(),
        ),
        onlyUpdateSecondary: shouldUpdateSecondaryOnly);

    return result;
  }
}

class FavoriteProjectListCubit extends ProjectListCubit {
  FavoriteProjectListCubit(
    super.projectRepository,
  ) : super(
          loader: ListBlocUtil.listLoader<ProjectModel, ProjectListFilter>(
            loader: ([filter]) => projectRepository.getAll(
              offset: filter?.offset,
              limit: filter?.limit,
              isFavorite: true,
              search: filter?.search,
              returnOnlySecondary: true,
              showMarkedAsDeleted: false,
            ),
          ),
        );
}

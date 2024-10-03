import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/utils/utils.dart';

import '../../../sync/blocs/syncable_data_cubit.dart';

typedef ProjectDataState = Data<ProjectModel, ProjectRetrieveFilter>;

class ProjectDataCubit
    extends SyncableDataCubit<ProjectModel, ProjectRetrieveFilter> {
  final ProjectRepository projectRepository;
  ProjectDataCubit(this.projectRepository,
      {Future<ProjectModel> Function([ProjectRetrieveFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.dataLoader<ProjectModel, ProjectRetrieveFilter>(
                loader: ([filter]) async {
                  final result = await projectRepository.getById(
                    filter!.id,
                    returnOnlySecondary: true,
                  );
                  if (result != null) {
                    return result;
                  } else {
                    throw Exception('Project not found');
                  }
                },
              ),
          projectRepository,
        );
}

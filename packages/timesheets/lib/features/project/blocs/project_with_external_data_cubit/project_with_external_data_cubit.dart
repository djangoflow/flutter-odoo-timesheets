import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/project/blocs/project_with_external_data_cubit/project_retrieve_filter.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/utils/utils.dart';

typedef ProjectWithExternalDataState
    = Data<ProjectWithExternalData?, ProjectRetrieveFilter>;

class ProjectWithExternalDataCubit
    extends DataCubit<ProjectWithExternalData?, ProjectRetrieveFilter> {
  final ProjectRepository projectRepository;

  ProjectWithExternalDataCubit(this.projectRepository)
      : super(
          ListBlocUtil.dataLoader<ProjectWithExternalData?,
              ProjectRetrieveFilter>(
            loader: ([filter]) =>
                projectRepository.getProjectWithExternalDataById(filter!.id),
          ),
        );
}

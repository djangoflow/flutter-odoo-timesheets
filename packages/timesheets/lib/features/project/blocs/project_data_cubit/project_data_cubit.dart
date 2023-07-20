import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/blocs/project_data_cubit/project_retrieve_filter.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/utils/utils.dart';

typedef ProjectDataState = Data<Project?, ProjectRetrieveFilter>;

class ProjectDataCubit extends DataCubit<Project?, ProjectRetrieveFilter> {
  final ProjectRepository projectRepository;

  ProjectDataCubit(this.projectRepository)
      : super(
          ListBlocUtil.dataLoader<Project?, ProjectRetrieveFilter>(
            loader: ([filter]) => projectRepository.getItemById(filter!.id),
          ),
        );
}

import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/blocs/project_list_cubit/project_list_filter.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/utils/utils.dart';

class ProjectListCubit extends ListCubit<Project, ProjectListFilter> {
  final ProjectRepository projectRepository;
  ProjectListCubit(this.projectRepository)
      : super(
          ListBlocUtil.listLoader<Project, ProjectListFilter>(
            loader: ([filter]) => projectRepository.getPaginatedItems(
              limit: filter?.limit,
              offset: filter?.offset,
              isLocal: filter?.isLocal,
            ),
          ),
        );
}

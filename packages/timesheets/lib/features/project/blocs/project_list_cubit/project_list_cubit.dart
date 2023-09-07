import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';

typedef ProjectListCubitState = Data<List<Project>, ProjectPaginationFilter>;

class ProjectListCubit
    extends CrudListCubit<Project, ProjectPaginationFilter, ProjectDataFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  ProjectListCubit({required super.repository});
}

class FavoriteProjectListCubit extends ProjectListCubit {
  FavoriteProjectListCubit({required super.repository});
}

class LocalProjectListCubit extends ProjectListCubit {
  LocalProjectListCubit({required super.repository});
}

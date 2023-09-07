import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/blocs/crud_data_cubit/crud_data_cubit.dart';
import 'package:timesheets/features/project/project.dart';

typedef ProjectDataCubitState = Data<Project, ProjectDataFilter>;

class ProjectDataCubit
    extends CrudDataCubit<Project, ProjectPaginationFilter, ProjectDataFilter> {
  ProjectDataCubit({required super.repository});
}

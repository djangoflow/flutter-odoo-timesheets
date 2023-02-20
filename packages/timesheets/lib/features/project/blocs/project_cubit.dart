import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';

part 'project_state.dart';

part 'project_cubit.freezed.dart';

part 'project_cubit.g.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(this._projectRepository) : super(const ProjectState.initial());

  final ProjectRepository _projectRepository;
  // TODO named arguments
  Future<void> loadProjects(int id, String password) async {
    emit(const ProjectState.loading());

    try {
      final List<Project> projects =
          await _projectRepository.getProjects(id: id, password: password);

      emit(ProjectState.success(projects));
    } on OdooRepositoryException catch (e) {
      emit(ProjectState.error(e.message));
    } on Exception catch (e) {
      emit(ProjectState.error(e.toString()));
    }
  }
}

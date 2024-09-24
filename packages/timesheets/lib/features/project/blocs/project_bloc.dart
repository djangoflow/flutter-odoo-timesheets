// lib/features/projects/blocs/project_bloc.dart
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import '../data/models/project_model.dart';
import '../data/repositories/project_repository.dart';

class ProjectBloc extends SyncBloc<ProjectModel> {
  ProjectBloc(ProjectRepository super.repository);
}

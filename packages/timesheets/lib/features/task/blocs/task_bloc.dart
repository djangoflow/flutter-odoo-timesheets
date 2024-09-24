// lib/features/tasks/blocs/task_bloc.dart
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

class TaskBloc extends SyncBloc<TaskModel> {
  TaskBloc(TaskRepository super.repository);
}

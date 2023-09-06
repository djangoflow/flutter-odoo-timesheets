import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

export 'data/repositories/in_memory_project_repository.dart';

/// InMemoryBackend is a simple in-memory backend for the timesheets app.
class InMemoryBackend {
  final List<Project> projects = [];
  final List<Task> tasks = [];
}

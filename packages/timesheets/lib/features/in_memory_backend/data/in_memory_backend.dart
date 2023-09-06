import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

/// InMemoryBackend is a simple in-memory backend for the timesheets app.
class InMemoryBackend {
  final List<Project> projects = [];
  final List<Task> tasks = [];
  final List<Timesheet> timesheets = [];
}

// ignore_for_file: unnecessary_null_comparison

import 'package:timesheets/features/in_memory_backend/data/repositories/in_memory_timesheet_repository.dart';
import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

import 'in_memory_task_with_project_repositroy.dart';

class InMemoryTimesheetWithTaskRepository
    implements TimesheetWithTaskProjectRepository {
  final InMemoryTimesheetRepository timesheetRepository;
  final InMemoryTaskWithProjectRepository taskWithProjectRepository;

  InMemoryTimesheetWithTaskRepository({required InMemoryBackend backend})
      : timesheetRepository = InMemoryTimesheetRepository(backend: backend),
        taskWithProjectRepository =
            InMemoryTaskWithProjectRepository(backend: backend);

  @override
  Future<int> createItem(TimesheetWithTaskProject item) =>
      timesheetRepository.createItem(
        item.timesheet,
      );

  @override
  Future<int> deleteItem(int id) => timesheetRepository.deleteItem(id);

  @override
  Future<List<TimesheetWithTaskProject>> getAllItems() async {
    final timesheets = (await timesheetRepository.getAllItems())
        .where((element) => element.taskId != null);
    final timesheetsWithTask = await _toTimesheetWithTasks(timesheets);

    return timesheetsWithTask;
  }

  @override
  Future<TimesheetWithTaskProject?> getItemById(int id) async {
    final timesheet = await timesheetRepository.getItemById(id);

    if (timesheet == null) {
      return null;
    } else {
      if (timesheet.taskId == null) {
        return null;
      }

      final taskWithProject =
          await taskWithProjectRepository.getItemById(timesheet.taskId);
      if (taskWithProject == null) {
        return null;
      } else {
        return TimesheetWithTaskProject(
          timesheet: timesheet,
          taskWithProject: taskWithProject,
        );
      }
    }
  }

  @override
  Future<List<TimesheetWithTaskProject>> getPaginatedItems(
      [TimesheetPaginatedFilter? filter]) async {
    final timesheets = await timesheetRepository.getPaginatedItems(filter);
    final timesheetsWithTask = await _toTimesheetWithTasks(timesheets);

    return timesheetsWithTask;
  }

  @override
  Future<void> updateItem(TimesheetWithTaskProject item) async {
    await timesheetRepository.updateItem(item.timesheet);
  }

  @override
  Future<bool> exists(int id) => timesheetRepository.exists(id);

  Future<List<TimesheetWithTaskProject>> _toTimesheetWithTasks(
      Iterable<Timesheet> timesheets) async {
    final timesheetsWithTaskProject = <TimesheetWithTaskProject>[];
    for (final timesheet in timesheets) {
      if (timesheet.taskId == null) {
        continue;
      }
      final taskWithProject =
          await taskWithProjectRepository.getItemById(timesheet.taskId);
      if (taskWithProject != null) {
        timesheetsWithTaskProject.add(
          TimesheetWithTaskProject(
            timesheet: timesheet,
            taskWithProject: taskWithProject,
          ),
        );
      }
    }

    return timesheetsWithTaskProject;
  }
}

// ignore_for_file: unnecessary_null_comparison

import 'package:timesheets/features/in_memory_backend/in_memory_backend.dart';
import 'package:timesheets/features/task/blocs/task_data_cubit/task_data_filter.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_data_cubit/timesheet_data_filter.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

import 'in_memory_task_with_project_repositroy.dart';

class InMemoryTimesheetWithTaskProjectRepository
    implements TimesheetWithTaskProjectRepository {
  final InMemoryTimesheetRepository timesheetRepository;
  final InMemoryTaskWithProjectRepository taskWithProjectRepository;

  InMemoryTimesheetWithTaskProjectRepository({required InMemoryBackend backend})
      : timesheetRepository = InMemoryTimesheetRepository(backend: backend),
        taskWithProjectRepository =
            InMemoryTaskWithProjectRepository(backend: backend);

  @override
  Future<TimesheetWithTaskProject> createItem(
      TimesheetWithTaskProject item) async {
    final timesheet = await timesheetRepository.createItem(
      item.timesheet,
    );

    return TimesheetWithTaskProject(
      timesheet: timesheet,
      taskWithProject: item.taskWithProject,
    );
  }

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
  Future<TimesheetWithTaskProject> getItemById(
      [TimesheetDataFilter? filter]) async {
    if (filter == null) {
      throw Exception('DataFilter is null');
    }
    final timesheet = await timesheetRepository.getItemById(filter);

    final taskWithProject = await taskWithProjectRepository
        .getItemById(TaskDataFilter(id: timesheet.taskId));

    return TimesheetWithTaskProject(
      timesheet: timesheet,
      taskWithProject: taskWithProject,
    );
  }

  @override
  Future<List<TimesheetWithTaskProject>> getPaginatedItems(
      [TimesheetPaginationFilter? filter]) async {
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
      final taskWithProject = await taskWithProjectRepository
          .getItemById(TaskDataFilter(id: timesheet.taskId));
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

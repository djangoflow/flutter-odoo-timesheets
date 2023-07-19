import 'package:bloc/bloc.dart';
import 'package:timesheets/features/odoo/data/models/odoo_timesheet.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';

import 'sync_state.dart';

export 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  final ProjectRepository projectRepository;
  final TaskRepository taskRepository;
  final TimesheetRepository timesheetRepository;
  final OdooTaskRepository odooTaskRepository;
  final OdooTimesheetRepository odooTimesheetRepository;
  final OdooProjectRepository odooProjectRepository;

  SyncCubit({
    required this.projectRepository,
    required this.taskRepository,
    required this.timesheetRepository,
    required this.odooTaskRepository,
    required this.odooTimesheetRepository,
    required this.odooProjectRepository,
  }) : super(const SyncState.initial());

  // Handle the SyncData event
  Future<void> syncData(int backendId) async {
    try {
      emit(const SyncState.syncing());

      // Fetch projects from Odoo and insert/update in the local database
      List<OdooProject> odooProjects = await odooProjectRepository.getProjects(
        backendId: backendId,
      );
      await projectRepository.syncWithOdooProjects(
        backendId: backendId,
        odooProjects: odooProjects,
      );
      // await projectRepository.syncProjects(projects);

      // Fetch tasks from Odoo and insert/update in the local database
      // final odooProjectIds = odooProjects.map((e) => e.id).toList();
      // List<OdooTask> odooTasks = await odooTaskRepository.getTasksByProjectIds(
      //     backendId: backendId, projectIds: odooProjectIds);

      // Fetch timesheets from Odoo and insert/update in the local database

      emit(const SyncState.success());
    } catch (error) {
      emit(const SyncState.failure());
      rethrow;
    }
  }
}

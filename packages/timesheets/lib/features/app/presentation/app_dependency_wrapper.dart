import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/data/repositories/odoo_client_repository.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class AppDependencyWrapper extends StatelessWidget {
  const AppDependencyWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DjangoflowOdooAuthCubit, DjangoflowOdooAuthState>(
        buildWhen: (previous, current) =>
            previous.session != current.session ||
            previous.status != current.status,
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated &&
              state.session != null &&
              state.session!.userId != 0) {
            return _AuthenticatedDependencies(child: child);
          } else {
            return child;
          }
        },
      );
}

class _AuthenticatedDependencies extends StatelessWidget {
  const _AuthenticatedDependencies({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final odooClient = context.read<OdooClientRepository>().getClient();
    if (odooClient == null) {
      throw Exception(
          'OdooClient not initialized. Call initializeClient() first.');
    }
    final odooAuthCubit = context.read<DjangoflowOdooAuthCubit>();
    final dbName = odooClient.sessionId?.dbName;
    final baseUrl = odooAuthCubit.state.baseUrl;
    if (dbName == null || baseUrl == null) {
      throw Exception(
          'OdooClient not initialized. Call initializeClient() first.');
    }
    final appDatabase = context.read<AppDatabase>();
    final idMappingRepository = context.read<AppIdMappingRepository>();
    final connectionStateProvider = context.read<ConnectionStateProvider>();

    final syncRegistryRepository = context.read<AppSyncRegistryRepository>();
    final syncBackendCubit = context.watch<SyncBackendCubit>();
    final odooBackendId =
        syncBackendCubit.getBackendId(baseUrl, SyncBackendTypes.odoo.name);
    final driftBackendId =
        syncBackendCubit.getBackendId(baseUrl, SyncBackendTypes.drift.name);
    if (odooBackendId == null || driftBackendId == null) {
      return const Scaffold(body: ParticleLoadingIndicator());
    }
    final projectDriftBackend =
        ProjectDriftBackend(appDatabase, driftBackendId);
    final taskDriftBackend = TaskDriftBackend(appDatabase, driftBackendId);
    final taskRelationDriftBackend =
        TaskRelationalDriftBackend(appDatabase, driftBackendId);
    final timesheetDriftBackend =
        TimesheetDriftBackend(appDatabase, driftBackendId);
    final timesheetRelationalDriftBackend = TimesheetRelationalDriftBackend(
      appDatabase,
      driftBackendId,
    );
    // Odoo Backends
    final projectOdooBackend =
        ProjectOdooBackend(odooClient, connectionStateProvider);
    final taskOdooBackend =
        TaskOdooBackend(odooClient, connectionStateProvider);
    final taskRelationalOdooBackend = TaskRelationalOdooBackend(
      odooClient,
      connectionStateProvider,
      projectOdooBackend,
    );
    final timesheetOdooBackend = TimesheetOdooBackend(
      odooClient,
      connectionStateProvider,
    );

    final timesheetRelationalOdooBackend = TimesheetRelationalOdooBackend(
      odooClient,
      connectionStateProvider,
      projectOdooBackend,
      taskOdooBackend,
    );
    // Sync Strategies
    final projectSyncStrategy =
        DriftOdooSyncStrategy<ProjectModel, ProjectProjects>(
      syncRegistryRepository,
      driftBackendId,
      odooBackendId,
      idMappingRepository,
    );

    final taskSyncStrategy = DriftOdooSyncStrategy<TaskModel, ProjectTasks>(
      syncRegistryRepository,
      driftBackendId,
      odooBackendId,
      idMappingRepository,
    );

    final timesheetSyncStrategy = TimesheetDriftOdooSyncStrategy(
      syncRegistryRepository,
      driftBackendId,
      odooBackendId,
      idMappingRepository,
    );

    // Repositories
    final projectRepository = ProjectRepository(
      projectOdooBackend,
      projectDriftBackend,
      projectSyncStrategy,
    );

    final taskRepository = TaskRepository(
      taskOdooBackend,
      taskDriftBackend,
      taskSyncStrategy,
    );

    final taskRelationalRepository = TaskRelationalRepository(
      taskRelationalOdooBackend,
      taskRelationDriftBackend,
      taskSyncStrategy,
      {
        'project': projectRepository,
      },
    );

    final timesheetRepository = TimesheetRepository(
      timesheetOdooBackend,
      timesheetDriftBackend,
      timesheetSyncStrategy,
    );

    final timesheetRelationalRepository = TimesheetRelationalRepository(
      timesheetRelationalOdooBackend,
      timesheetRelationalDriftBackend,
      timesheetSyncStrategy,
      {
        'project': projectRepository,
        'task': taskRepository,
      },
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProjectRepository>.value(
          value: projectRepository,
        ),
        RepositoryProvider<TaskRepository>.value(
          value: taskRepository,
        ),
        RepositoryProvider<TaskRelationalRepository>.value(
          value: taskRelationalRepository,
        ),
        RepositoryProvider<TimesheetRepository>.value(
          value: timesheetRepository,
        ),
        RepositoryProvider<TimesheetRelationalRepository>.value(
          value: timesheetRelationalRepository,
        ),
      ],
      child: Builder(
        builder: (context) =>
            SyncProvider<TimesheetModel, TimesheetRelationalRepository>(
          odooModelName: TimesheetModel.odooModelName,
          builder: (context, backendId) => child,
        ),
      ),
    );
  }
}

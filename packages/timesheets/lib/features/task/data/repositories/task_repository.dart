// lib/features/tasks/repositories/task_repository.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:timesheets/features/sync/sync.dart';

import '../models/task_model.dart';

class TaskRepository extends DriftOdooSyncRepository<TaskModel, ProjectTasks> {
  TaskRepository(
    super.primaryBackend,
    super.secondaryBackend,
    super.syncStrategy,
  );

  @override
  String get modelName => TaskModel.odooModelName;
}

// lib/features/tasks/data/backends/task_odoo_backend.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import '../models/task_model.dart';

class TaskOdooBackend extends OdooBackend<TaskModel> {
  TaskOdooBackend(
    super.odooClient,
    super.connectionStateProvider,
  );

  @override
  TaskModel fromJson(Map<String, dynamic> json) => TaskModel.fromJson(json);

  @override
  List<String> getFields() => TaskModel.odooFields;

  @override
  Map<String, dynamic> toOdooJson(TaskModel item) =>
      removeOdooReservedFields(item.toOdooJson());

  @override
  String get modelName => TaskModel.odooModelName;
}

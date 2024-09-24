// lib/features/projects/data/backends/project_odoo_backend.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import '../models/project_model.dart';

class ProjectOdooBackend extends OdooBackend<ProjectModel> {
  ProjectOdooBackend(
    super.odooClient,
    super.connectionStateProvider,
  );

  @override
  ProjectModel fromJson(Map<String, dynamic> json) =>
      ProjectModel.fromJson(json);

  @override
  List<String> getFields() => ProjectModel.odooFields;

  @override
  Map<String, dynamic> toOdooJson(ProjectModel item) =>
      removeOdooReservedFields(item.toOdooJson());

  @override
  String get modelName => ProjectModel.odooModelName;
}

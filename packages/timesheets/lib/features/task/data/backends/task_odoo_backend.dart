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

  @override
  Future<List<TaskModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? projectId,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final domain = [
      ['active', '=', true],
      if (ids != null && ids.isNotEmpty) ['id', 'in', ids],
      if (since != null) ['write_date', '>=', since.toIso8601String()],
      if (projectId != null) ['project_id', '=', projectId],
      if (search != null && search.isNotEmpty) ['name', 'ilike', search],
    ];

    final response = await odooClient.callKw({
      'model': modelName,
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': getFields(),
        'domain': domain,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    });

    return deserializeListResponse(response as List);
  }
}

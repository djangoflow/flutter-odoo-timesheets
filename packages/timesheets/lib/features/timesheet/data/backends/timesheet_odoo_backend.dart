// lib/features/analytic_lines/data/backends/analytic_line_odoo_backend.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import '../models/analytic_line_model.dart';

class TimesheetOdooBackend extends OdooBackend<TimesheetModel> {
  TimesheetOdooBackend(
    super.odooClient,
    super.connectionStateProvider,
  );

  @override
  TimesheetModel fromJson(Map<String, dynamic> json) =>
      TimesheetModel.fromJson(json);

  @override
  List<String> getFields() => TimesheetModel.odooFields;

  @override
  Map<String, dynamic> toOdooJson(TimesheetModel item) =>
      removeOdooReservedFields(item.toOdooJson());

  @override
  String get modelName => TimesheetModel.odooModelName;

  @override
  Future<List<TimesheetModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? projectId,
    int? taskId,
    int? limit,
    int? offset,
  }) async {
    final domain = [
      '|',
      ['project_id.active', '=', true],
      ['project_id', '=', false],
      '|',
      ['task_id.active', '=', true],
      ['task_id', '=', false],
      if (ids != null && ids.isNotEmpty) ['id', 'in', ids],
      if (since != null) ['write_date', '>=', since.toIso8601String()],
      if (projectId != null) ['project_id', '=', projectId],
      if (taskId != null) ['task_id', '=', taskId],
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

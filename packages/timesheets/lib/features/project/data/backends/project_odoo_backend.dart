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

  @override
  Future<List<ProjectModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? limit,
    int? offset,
    bool? isFavorite,
    String? search,
  }) async {
    final domain = <List<dynamic>>[
      ['active', '=', true],
    ];
    if (ids != null && ids.isNotEmpty) {
      domain.add(['id', 'in', ids]);
    }
    if (since != null) {
      domain.add(['write_date', '>', since.toIso8601String()]);
    }
    if (isFavorite != null) {
      domain.add(['is_favorite', '=', isFavorite]);
    }
    if (search != null && search.isNotEmpty) {
      domain.add(['name', 'ilike', search]);
    }

    final records = await odooClient.callKw({
      'model': modelName,
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': getFields(),
        if (domain.isNotEmpty) 'domain': domain,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    });

    return deserializeListResponse(records as List);
  }
}

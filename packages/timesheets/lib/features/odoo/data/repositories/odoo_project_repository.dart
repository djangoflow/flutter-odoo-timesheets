import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/data/models/odoo_project.dart';

import '../odoo_api_method.dart';
import 'odoo_repository_base.dart';

///Repository to fetch projects data using [OdooRepository]
class OdooProjectRepository extends OdooRpcRepositoryBase {
  OdooProjectRepository(super.rpcClient);

  Future<List<OdooProject>> getProjects(
      {required int backendId, int? limit, int? offset, String? search}) async {
    Map<String, dynamic> optionalParams =
        buildFilterableFields(_defaultProjectFields);
    if (limit != null && offset != null) {
      optionalParams.addAll({
        offsetKey: offset,
        limitKey: limit,
      });
    }
    final searchParameters = [];
    if (search != null) {
      searchParameters.add(
        [
          name,
          caseInsensitiveComparison,
          '$search%',
        ],
      );
    }

    var response = await odooCallMethod(
      backendId: backendId,
      odooModel: projectModel,
      method: OdooApiMethod.searchRead.name,
      parameters: [
        [searchParameters],
        optionalParams,
      ],
    );

    final projects = <OdooProject>[];
    for (final project in response) {
      projects.add(OdooProject.fromJson(project));
    }
    return projects;
  }

  Future<void> getModelFields({required int backendId}) async {
    final response = await odooCallMethod(
      backendId: backendId,
      odooModel: projectModel,
      method: OdooApiMethod.fieldsGet.name,
      parameters: [
        [],
      ],
    );

    // Clipboard.setData(ClipboardData(text: response.toString()));

    debugPrint(response);
  }

  static const _defaultProjectFields = [
    'id',
    'name',
    'task_ids',
    'color',
    'is_favorite',
    'task_count',
  ];
}

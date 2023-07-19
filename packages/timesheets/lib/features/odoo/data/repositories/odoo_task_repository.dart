import 'package:flutter/services.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/odoo.dart';

///Repository to fetch task data
class OdooTaskRepository extends OdooRpcRepositoryBase {
  OdooTaskRepository(super.rpcClient);

  Future<List<OdooTask>> getTasksByProjectId({
    required int backendId,
    required int projectId,
    int? limit,
    int? offset,
    String? search,
  }) async {
    Map<String, dynamic> optionalParams = buildFilterableFields([name]);
    if (limit != null && offset != null) {
      optionalParams.addAll({
        offsetKey: offset,
        limitKey: limit,
      });
    }

    final searchParameters = [
      [
        'project_id',
        '=',
        projectId,
      ],
    ];
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
      odooModel: taskModel,
      method: OdooApiMethod.searchRead.name,
      parameters: [
        [searchParameters],
        optionalParams,
      ],
    );

    final tasks = <OdooTask>[];
    for (final task in response) {
      task['project_id'] = projectId;
      tasks.add(OdooTask.fromJson(task));
    }
    return tasks;
  }

  Future<List<OdooTask>> getTasksByProjectIds({
    required int backendId,
    required List<int> projectIds,
    int? limit,
    int? offset,
    String? search,
  }) async {
    Map<String, dynamic> optionalParams = buildFilterableFields([
      name,
      'project_id',
      'date_start',
    ]);
    if (limit != null && offset != null) {
      optionalParams.addAll({
        offsetKey: offset,
        limitKey: limit,
      });
    }

    final searchParameters = [
      [
        'project_id',
        'in',
        projectIds,
      ],
    ];
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
      odooModel: taskModel,
      method: OdooApiMethod.searchRead.name,
      parameters: [
        [searchParameters],
        optionalParams,
      ],
    );

    final tasks = <OdooTask>[];
    for (final task in response) {
      tasks.add(OdooTask.fromJson(task));
    }
    return tasks;
  }

  Future<void> getTasksByTaskIds(List<int> taskIds) async {}

  /// Get available fields for [taskModel]
  Future<void> getModelFields({required int backendId}) async {
    final response = await odooCallMethod(
      backendId: backendId,
      odooModel: taskModel,
      method: OdooApiMethod.fieldsGet.name,
      parameters: [
        [],
      ],
    );

    Clipboard.setData(ClipboardData(text: response.toString()));
    print(response);
  }
}

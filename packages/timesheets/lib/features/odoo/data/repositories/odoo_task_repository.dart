import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/odoo.dart';

///Repository to fetch task data
class OdooTaskRepository extends OdooRpcRepositoryBase {
  OdooTaskRepository(super.rpcClient);

  Future<List<OdooTask>> getTasks({
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
}

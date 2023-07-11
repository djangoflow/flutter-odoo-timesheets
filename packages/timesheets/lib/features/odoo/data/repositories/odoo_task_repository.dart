import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/odoo.dart';

///Repository to fetch task data
class OdooTaskRepository extends OdooRpcRepositoryBase {
  OdooTaskRepository(super.rpcClient);

  Future<List<OdooTask>> getTasks([OdooTaskListFilter? filter]) async {
    int? projectId = filter?.projectId;

    if (projectId == null) {
      throw const OdooRepositoryException('Must provide a non-null projectId');
    }

    Map<String, dynamic> optionalParams = buildFilterableFields([name]);
    if (filter != null) {
      optionalParams.addAll({
        offset: filter.offset,
        limit: filter.limit,
      });
    }

    final searchParameters = [
      [
        'project_id',
        '=',
        projectId,
      ],
    ];
    if (filter != null && filter.search != null) {
      searchParameters.add(
        [
          name,
          caseInsensitiveComparison,
          '${filter.search}%',
        ],
      );
    }

    var response = await odooCallMethod(
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

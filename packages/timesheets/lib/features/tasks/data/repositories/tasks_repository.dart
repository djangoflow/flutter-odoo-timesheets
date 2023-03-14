import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/tasks/tasks.dart';

///Repository to fetch task data
class TaskRepository extends OdooRpcRepositoryBase {
  TaskRepository(super.rpcClient);

  Future<List<Task>> getTasks([TaskListFilter? filter]) async {
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

    final tasks = <Task>[];
    for (final task in response) {
      task['project_id'] = projectId;
      tasks.add(Task.fromJson(task));
    }
    return tasks;
  }
}

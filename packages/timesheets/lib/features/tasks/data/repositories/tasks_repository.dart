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

    ///TODO find a way to use this in a better way
    final requiredParameters = [
      [
        [
          'project_id',
          '=',
          projectId,
        ],
      ]
    ];

    if (filter != null && filter.search != null) {
      requiredParameters[0].add(
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
        requiredParameters,
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

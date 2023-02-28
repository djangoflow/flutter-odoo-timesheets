import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/tasks/tasks.dart';

///Repository to fetch task data
class TaskRepository extends OdooRpcRepositoryBase {
  TaskRepository(super.rpcClient);

  Future getTasks({required int projectId}) async {
    var response = await odooCallMethod(
      odooModel: taskModel,
      method: OdooApiMethod.searchRead.name,
      parameters: [
        [
          [
            [
              'project_id',
              '=',
              projectId,
            ]
          ]
        ],
        buildFilterableFields(['name']),
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

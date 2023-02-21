import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_method.dart';
import 'package:timesheets/features/tasks/tasks.dart';

///Repository to fetch task data
class TaskRepository extends OdooRpcRepositoryBase {
  Future getTasks({required int projectId}) async {
    var response = await rpcGetObject(
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

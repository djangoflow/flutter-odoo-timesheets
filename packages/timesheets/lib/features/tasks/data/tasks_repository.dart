import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_method.dart';
import 'package:timesheets/features/tasks/tasks.dart';

///Repository to fetch task data
class TaskRepository extends OdooRpcRepositoryBase {
  Future getTasks({
    required int id,
    required int projectId,
    required String password,
  }) async {
    var response = await getObject(
      id,
      password,
      taskMethod,
      OdooApiMethod.searchRead.name,
      [
        [
          [
            'project_id',
            '=',
            projectId,
          ]
        ]
      ],
      optionalParams: buildFilterableFields(['name']),
    );

    List<Task> tasks = [];
    for (final task in response) {
      task['project_id'] = projectId;
      tasks.add(Task.fromJson(task));
    }
    return tasks;
  }
}

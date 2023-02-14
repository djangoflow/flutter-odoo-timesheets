import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/tasks/tasks.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;

///Repository to fetch task data using [OdooRepository]
class TaskRepository {
  static final TaskRepository _instance = TaskRepository._internal();

  factory TaskRepository() => _instance;

  TaskRepository._internal();

  final OdooRepository _baseRepo = OdooRepository();

  Future getTasks(
    int id,
    int projectId,
    String password,
  ) async {
    // Map<String,dynamic> optionalParams = _baseRepo.buildFilterableFields(['name']);

    var response = await _baseRepo.getObject(
      id,
      password,
      'project.task',
      'search_read',
      [
        [
          [
            'project_id',
            '=',
            projectId,
          ]
        ]
      ],
      optionalParams: _baseRepo.buildFilterableFields(['name']),
    );

    List<Task> tasks = [];
    for (final task in response) {
      task['project_id'] = projectId;
      tasks.add(Task.fromJson(task));
    }
    return tasks;
  }

  ///Handles errors generated due to various operations in [OdooRepository] using [OdooRepositoryException]
  handleError(error) {
    if (error.runtimeType == xml_rpc.Fault) {
      throw OdooRepositoryException(error.text);
    } else {
      throw const OdooRepositoryException();
    }
  }
}

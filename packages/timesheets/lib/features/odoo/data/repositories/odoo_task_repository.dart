import 'package:flutter/foundation.dart';
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
    Map<String, dynamic> optionalParams =
        buildFilterableFields(_taskDefaultFields);
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
    Map<String, dynamic> optionalParams =
        buildFilterableFields(_taskDefaultFields);
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

  Future<List<OdooTask>> getTasksByTaskIds({
    required int backendId,
    required List<int> taskIds,
    int offset = 0, // Add an offset parameter to fetch data in chunks
    List<OdooTask> previousTasks = const [], // To store previous tasks
  }) async {
    Map<String, dynamic> optionalParams =
        buildFilterableFields(_taskDefaultFields);

    // Add limit and offset to the optionalParams to fetch data in chunks
    optionalParams[limitKey] = 5; // Or any other chunk size you prefer
    optionalParams[offsetKey] = offset;

    final searchParameters = [
      [
        'id',
        'in',
        taskIds,
      ],
    ];

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

    // If the response is not empty, call the method recursively with an increased offset
    if (response.isNotEmpty) {
      final nextTasks = await getTasksByTaskIds(
        backendId: backendId,
        taskIds: taskIds,
        offset: offset + optionalParams[limitKey] as int,
        previousTasks: tasks,
      );
      return previousTasks + nextTasks;
    } else {
      return previousTasks + tasks;
    }
  }

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

    // Clipboard.setData(ClipboardData(text: response.toString()));
    debugPrint(response.toString());
  }

  static const _taskDefaultFields = [
    'id',
    'name',
    'project_id',
    'date_start',
    'date_end',
    'date_deadline',
    'priority',
    'color',
    'timesheet_ids',
    'description',
  ];
}

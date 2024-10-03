import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';

import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetRelationalOdooBackend extends TimesheetOdooBackend
    with OdooRelationalFetchMixin<TimesheetModel> {
  TimesheetRelationalOdooBackend(
    super.odooClient,
    super.connectionStateProvider,
    this.projectBackend,
    this.taskBackend,
  );

  final OdooBackend<ProjectModel> projectBackend;
  final OdooBackend<TaskModel> taskBackend;

  @override
  Map<String, OdooBackend<SyncModel>> get relationalBackends => {
        'project.project': projectBackend,
        'project.task': taskBackend,
      };

  @override
  Map<String, String> get relationalFields => {
        'project_id': 'project.project',
        'task_id': 'project.task',
      };

  @override
  int? getRelationalId(TimesheetModel item, String fieldName) {
    switch (fieldName) {
      case 'project_id':
        return item.projectId;
      case 'task_id':
        return item.taskId;
      default:
        return null;
    }
  }

  @override
  TimesheetModel mergeRelatedData(
          TimesheetModel item, Map<String, dynamic> relatedData) =>
      item.copyWith(
        project: relatedData['project_id'] != null
            ? ProjectModel.fromJson(relatedData['project_id'])
            : null,
        task: relatedData['task_id'] != null
            ? TaskModel.fromJson(relatedData['task_id'])
            : null,
      );

  @override
  TimesheetModel fromJson(Map<String, dynamic> json) {
    final processedJson = processRelationalFields(json);
    return TimesheetModel.fromJson(processedJson);
  }

  @override
  Future<List<TimesheetModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? projectId,
    int? taskId,
    int? limit,
    int? offset,
  }) async {
    final analyticLines = await super.getAll(
      ids: ids,
      since: since,
      projectId: projectId,
      taskId: taskId,
      limit: limit,
      offset: offset,
    );

    return Future.wait(
      analyticLines.map(
        (analyticLine) async {
          final relatedData = await getRelatedData(analyticLine);
          return mergeRelatedData(analyticLine, relatedData);
        },
      ),
    );
  }

  @override
  Future<TimesheetModel?> getById(int id) async {
    final analyticLine = await super.getById(id);
    if (analyticLine != null) {
      final relatedData = await getRelatedData(analyticLine);
      return mergeRelatedData(analyticLine, relatedData);
    }
    return null;
  }
}

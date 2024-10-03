import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';

import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

class TaskRelationalOdooBackend extends TaskOdooBackend
    with OdooRelationalFetchMixin<TaskModel> {
  TaskRelationalOdooBackend(
      super.database, super.backendId, this.projectBackend);

  final OdooBackend<ProjectModel> projectBackend;

  @override
  int? getRelationalId(TaskModel item, String fieldName) {
    switch (fieldName) {
      case 'project_id':
        return item.projectId;
      default:
        return null;
    }
  }

  @override
  TaskModel mergeRelatedData(
          TaskModel item, Map<String, dynamic> relatedData) =>
      item.copyWith(
        project: relatedData['project_id'] != null
            ? ProjectModel.fromJson(relatedData['project_id'])
            : null,
      );

  @override
  Map<String, OdooBackend<SyncModel>> get relationalBackends => {
        'project.project': projectBackend,
      };

  @override
  Map<String, String> get relationalFields => {
        'project_id': 'project.project',
      };
  @override
  TaskModel fromJson(Map<String, dynamic> json) {
    final processedJson = processRelationalFields(json);
    return TaskModel.fromJson(processedJson);
  }

  @override
  Future<List<TaskModel>> getAll({
    List<int>? ids,
    int? projectId,
    DateTime? since,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final tasks = await super.getAll(
      ids: ids,
      since: since,
      projectId: projectId,
      search: search,
      limit: limit,
      offset: offset,
    );

    return Future.wait(
      tasks.map(
        (task) async {
          final relatedData = await getRelatedData(task);
          return mergeRelatedData(task, relatedData);
        },
      ),
    );
  }

  @override
  Future<TaskModel?> getById(int id) async {
    final task = await super.getById(id);
    if (task != null) {
      final relatedData = await getRelatedData(task);
      return mergeRelatedData(task, relatedData);
    }
    return null;
  }
}

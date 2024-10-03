import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';

class AppIdMappingRepository extends IdMappingRepository {
  final AppDatabase database;

  AppIdMappingRepository(this.database);

  @override
  Future<void> updateRelatedFields(
      String modelName, int oldId, int newId) async {
    switch (modelName) {
      case 'project.project':
        await _updateProjectReferences(oldId, newId);
        break;
      case 'project.task':
        await _updateTaskReferences(oldId, newId);
        break;
      case 'account.analytic.line':
        // Analytic lines don't have dependencies, so no update needed
        break;
      default:
        throw UnimplementedError('ID mapping not implemented for $modelName');
    }
  }

  Future<void> _updateProjectReferences(int oldId, int newId) async {
    // Update tasks referencing this project
    await (database.update(database.projectTasks)
          ..where((t) => t.projectId.equals(oldId)))
        .write(ProjectTasksCompanion(projectId: Value(newId)));

    // Update analytic lines referencing this project
    await (database.update(database.analyticLines)
          ..where((a) => a.projectId.equals(oldId)))
        .write(AnalyticLinesCompanion(projectId: Value(newId)));
  }

  Future<void> _updateTaskReferences(int oldId, int newId) async {
    // Update analytic lines referencing this task
    await (database.update(database.analyticLines)
          ..where((a) => a.taskId.equals(oldId)))
        .write(AnalyticLinesCompanion(taskId: Value(newId)));
  }

  @override
  Future<void> batchUpdateRelatedFields(
      List<MapEntry<String, MapEntry<int, int>>> updates) async {
    await database.transaction(() async {
      for (final update in updates) {
        await updateRelatedFields(
            update.key, update.value.key, update.value.value);
      }
    });
  }
}

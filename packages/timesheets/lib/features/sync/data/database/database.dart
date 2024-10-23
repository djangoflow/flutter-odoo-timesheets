import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:flutter/foundation.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'database.drift.dart';
export 'database.drift.dart';

@TableIndex(name: 'analytic_lines_project_task', columns: {#projectId, #taskId})
@TableIndex(name: 'analytic_lines_status', columns: {#currentStatus})
@TableIndex(name: 'analytic_lines_favorite', columns: {#isFavorite})
class AnalyticLines extends BaseTable {
  DateTimeColumn get date => dateTime()();
  TextColumn get name => text()();
  IntColumn get projectId => integer().references(
        ProjectProjects,
        #id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get taskId => integer().references(
        ProjectTasks,
        #id,
        onDelete: KeyAction.restrict,
      )();

  RealColumn get unitAmount => real().nullable()();
  IntColumn get currentStatus =>
      intEnum<TimerStatus>().clientDefault(() => TimerStatus.initial.index)();
  DateTimeColumn get lastTicked => dateTime().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  /// could not use odoo fields directly as dateTime is reserved by drift fields
  DateTimeColumn get startTime => dateTime().nullable()();
  DateTimeColumn get endTime => dateTime().nullable()();

  TextColumn get showTimeControl => text().nullable()();

  @override
  Set<Column> get primaryKey => {backendId, id};
}

@TableIndex(name: 'project_projects_name', columns: {#name})
@TableIndex(name: 'project_projects_favorite', columns: {#isFavorite})
class ProjectProjects extends BaseTable {
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get color => integer().nullable()();
  TextColumn get name => text()();
  IntColumn get taskCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {backendId, id};
}

@TableIndex(name: 'project_tasks_project', columns: {#projectId})
@TableIndex(name: 'project_tasks_name', columns: {#name})
class ProjectTasks extends BaseTable {
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get color => integer().nullable()();
  DateTimeColumn get dateDeadline => dateTime().nullable()();
  DateTimeColumn get dateEnd => dateTime().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get name => text()();
  TextColumn get priority => text().nullable()();
  IntColumn get projectId => integer().references(
        ProjectProjects,
        #id,
        onDelete: KeyAction.restrict,
      )();

  @override
  Set<Column> get primaryKey => {backendId, id};
}

@DriftDatabase(
  tables: [
    AnalyticLines,
    ProjectProjects,
    ProjectTasks,
    SyncBackends,
    SyncRegistries,
  ],
)
final class AppDatabase extends $AppDatabase {
  AppDatabase()
      : super(
          driftDatabase(
            name: 'timesheets-app',
            web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
                onResult: (result) {
                  if (result.missingFeatures.isNotEmpty) {
                    debugPrint(
                        'Using ${result.chosenImplementation} due to unsupported '
                        'browser features: ${result.missingFeatures}');
                  }
                }),
          ),
        );

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            // Add new indexes
            await m.createIndex(Index('analytic_lines',
                'CREATE INDEX analytic_lines_project_task ON analytic_lines(project_id, task_id)'));
            await m.createIndex(Index('analytic_lines',
                'CREATE INDEX analytic_lines_status ON analytic_lines(current_status)'));
            await m.createIndex(Index('analytic_lines',
                'CREATE INDEX analytic_lines_favorite ON analytic_lines(is_favorite)'));

            await m.createIndex(Index('project_projects',
                'CREATE INDEX project_projects_name ON project_projects(name)'));
            await m.createIndex(Index('project_projects',
                'CREATE INDEX project_projects_favorite ON project_projects(is_favorite)'));

            await m.createIndex(Index('project_tasks',
                'CREATE INDEX project_tasks_project ON project_tasks(project_id)'));
            await m.createIndex(Index('project_tasks',
                'CREATE INDEX project_tasks_name ON project_tasks(name)'));
          }

          if (from < 3) {
            await m.addColumn(analyticLines, analyticLines.startTime);
            await m.addColumn(analyticLines, analyticLines.endTime);
          }

          if (from < 4) {
            await m.addColumn(analyticLines, analyticLines.showTimeControl);
          }
        },
      );
}

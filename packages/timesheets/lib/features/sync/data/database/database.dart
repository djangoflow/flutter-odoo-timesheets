// lib/database/database.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'database.drift.dart';
export 'database.drift.dart';

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
}

class ProjectProjects extends BaseTable {
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get color => integer().nullable()();
  TextColumn get name => text()();
  IntColumn get taskCount => integer().withDefault(const Constant(0))();
}

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
class AppDatabase extends $AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'hr_timesheet.sqlite'));
      return NativeDatabase.createInBackground(file);
    });

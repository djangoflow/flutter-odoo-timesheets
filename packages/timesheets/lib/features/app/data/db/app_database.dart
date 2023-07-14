// To open the database, add these imports to the existing file defining the
// database class. They are used to open the database.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/data/db/schema_versions.dart';
import 'package:timesheets/features/task/task.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Tasks,
    Backends,
    TaskBackends,
    Timesheets,
    Projects,
  ],
  daos: [
    TasksDao,
    BackendsDao,
    TaskBackendsDao,
    TimesheetsDao,
    ProjectsDao,
    TasksWithProjectDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  AppDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onUpgrade: stepByStep(
          from1To2: (m, schema) async {
            await customStatement('PRAGMA foreign_keys = OFF');
            // add new default constraint to onDelete cascade to tasks, timesheet_backends, timesheets
            transaction(() async {
              await m.alterTable(TableMigration(schema.tasks));
              await m.alterTable(TableMigration(schema.taskBackends));
              await m.alterTable(TableMigration(schema.timesheets));
            });
          },
        ),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await transaction(() async {
            final value = await into(backends).insert(
              BackendsCompanion(
                id: const Value(hardcodedBackendId),
                name: const Value('Odoo'),
                description: const Value('Odoo backend'),
                backendType: Value(BackendType.odoo.index),
              ),
              mode: InsertMode.insertOrReplace,
            );
            debugPrint('inserted backend $value');
          });
        },
      );
}

// the LazyDatabase util lets us find the right location for the file async.
LazyDatabase _openConnection() => LazyDatabase(() async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    });

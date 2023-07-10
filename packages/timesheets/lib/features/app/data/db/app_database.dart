// To open the database, add these imports to the existing file defining the
// database class. They are used to open the database.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
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
  ],
)
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  AppDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // disable foreign_keys before migrations
          await customStatement('PRAGMA foreign_keys = OFF');

          // await transaction(() async {
          //   // put your migration logic here
          // });

          // Assert that the schema is valid after migrations
          if (kDebugMode) {
            final wrongForeignKeys =
                await customSelect('PRAGMA foreign_key_check').get();
            assert(wrongForeignKeys.isEmpty,
                '${wrongForeignKeys.map((e) => e.data)}');
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
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

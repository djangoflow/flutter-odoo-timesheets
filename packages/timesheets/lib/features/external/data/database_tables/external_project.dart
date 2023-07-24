import 'package:drift/drift.dart';
import 'package:timesheets/features/project/project.dart';

import 'backend.dart';

class ExternalProjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get internalId => integer()
      .references(Projects, #id, onDelete: KeyAction.cascade)
      .nullable()();
  IntColumn get externalId => integer().nullable()();
  IntColumn get backendId => integer()
      .references(Backends, #id, onDelete: KeyAction.cascade)
      .nullable()();

  DateTimeColumn get lastSycned => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

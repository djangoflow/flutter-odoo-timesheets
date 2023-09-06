import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';

import '../../features_refactored/project/data/entities/project_entity.dart';

extension ProjectToProjectEntityExtensions on Project {
  ProjectEntity toProjectEntity() => ProjectEntity(
        id: id,
        name: name,
        active: active,
        color: color,
        isFavorite: isFavorite,
        taskCount: taskCount,
        taskIds: [],
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension ProjectEntityToProjectExtensions on ProjectEntity {
  Project toProject() {
    if (id == null) {
      throw ArgumentError.notNull('id can not be null');
    }

    if (createdAt == null) {
      throw ArgumentError.notNull('createdAt can not be null');
    }

    if (updatedAt == null) {
      throw ArgumentError.notNull('updatedAt can not be null');
    }

    return Project(
      id: id!,
      name: name,
      active: active,
      color: color,
      isFavorite: isFavorite,
      taskCount: taskCount,
      createdAt: createdAt!,
      updatedAt: updatedAt!,
    );
  }

  ProjectsCompanion toProjectCompanion() => ProjectsCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        name: name == null ? const Value.absent() : Value(name!),
        active: active == null ? const Value.absent() : Value(active!),
        color: color == null ? const Value.absent() : Value(color!),
        isFavorite:
            isFavorite == null ? const Value.absent() : Value(isFavorite!),
        taskCount: taskCount == null ? const Value.absent() : Value(taskCount!),
        createdAt: createdAt == null ? const Value.absent() : Value(createdAt!),
        updatedAt: updatedAt == null ? const Value.absent() : Value(updatedAt!),
      );
}

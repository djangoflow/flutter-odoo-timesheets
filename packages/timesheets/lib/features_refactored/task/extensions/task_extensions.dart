import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features_refactored/task/data/entities/task_entity.dart';

extension ProjectToTaskEntityExtensions on Task {
  TaskEntity toTaskEntity() => TaskEntity(
        id: id,
        name: name,
        active: active,
        dateDeadline: dateDeadline,
        dateEnd: dateEnd,
        dateStart: dateStart,
        description: description,
        priority: priority,
        projectId: projectId,
        stageId: stageId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension TaskEntityToProjectExtensions on TaskEntity {
  Task toProject() {
    if (id == null) {
      throw ArgumentError.notNull('id can not be null');
    }

    if (createdAt == null) {
      throw ArgumentError.notNull('createdAt can not be null');
    }

    if (updatedAt == null) {
      throw ArgumentError.notNull('updatedAt can not be null');
    }

    return Task(
      id: id!,
      name: name,
      active: active,
      dateDeadline: dateDeadline,
      dateEnd: dateEnd,
      dateStart: dateStart,
      description: description,
      priority: priority,
      projectId: projectId,
      stageId: stageId,
      createdAt: createdAt!,
      updatedAt: updatedAt!,
    );
  }

  TasksCompanion toProjectCompanion() => TasksCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        name: name == null ? const Value.absent() : Value(name!),
        active: active == null ? const Value.absent() : Value(active!),
        dateDeadline:
            dateDeadline == null ? const Value.absent() : Value(dateDeadline!),
        dateEnd: dateEnd == null ? const Value.absent() : Value(dateEnd!),
        dateStart: dateStart == null ? const Value.absent() : Value(dateStart!),
        description:
            description == null ? const Value.absent() : Value(description!),
        priority: priority == null ? const Value.absent() : Value(priority!),
        projectId: projectId == null ? const Value.absent() : Value(projectId!),
        stageId: stageId == null ? const Value.absent() : Value(stageId!),
        createdAt: createdAt == null ? const Value.absent() : Value(createdAt!),
        updatedAt: updatedAt == null ? const Value.absent() : Value(updatedAt!),
      );
}

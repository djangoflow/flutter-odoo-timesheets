// lib/features/tasks/data/models/task_model.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:drift/drift.dart';
import 'package:timesheets/features/sync/sync.dart';

class TaskModel extends SyncModel implements OdooModel, DriftModel {
  @override
  final int id;
  final bool active;
  final int? color;
  final DateTime? dateDeadline;
  final DateTime? dateEnd;
  final String? description;
  final String name;
  final String? priority;
  final int projectId;
  @override
  final DateTime createDate;
  @override
  final DateTime writeDate;
  @override
  final bool? isMarkedAsDeleted;

  TaskModel({
    required this.id,
    required this.active,
    this.color,
    this.dateDeadline,
    this.dateEnd,
    this.description,
    required this.name,
    this.priority,
    required this.projectId,
    required this.createDate,
    required this.writeDate,
    this.isMarkedAsDeleted,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'active': active,
        'color': color,
        'date_deadline': dateDeadline?.toIso8601String(),
        'date_end': dateEnd?.toIso8601String(),
        'description': description,
        'name': name,
        'priority': priority,
        'project_id': projectId,
        'create_date': createDate.toIso8601String(),
        'write_date': writeDate.toIso8601String(),
        'is_marked_as_deleted': isMarkedAsDeleted,
      };

  @override
  Map<String, dynamic> toOdooJson() => {
        'id': id,
        'active': active,
        'color': color,
        'date_deadline': dateDeadline?.toIso8601String(),
        'date_end': dateEnd?.toIso8601String(),
        'description': description,
        'name': name,
        'priority': priority,
        'project_id': projectId,
      };

  @override
  UpdateCompanion<dynamic> toCompanion() => ProjectTasksCompanion(
        id: Value(id),
        active: Value(active),
        color: Value(color),
        dateDeadline: Value(dateDeadline),
        dateEnd: Value(dateEnd),
        description: Value(description),
        name: Value(name),
        priority: Value(priority),
        projectId: Value(projectId),
      );

  @override
  TaskModel copyWith({
    int? id,
    bool? active,
    int? color,
    DateTime? dateDeadline,
    DateTime? dateEnd,
    String? description,
    String? name,
    String? priority,
    int? projectId,
    DateTime? createDate,
    DateTime? writeDate,
    bool? isMarkedAsDeleted,
  }) =>
      TaskModel(
        id: id ?? this.id,
        active: active ?? this.active,
        color: color ?? this.color,
        dateDeadline: dateDeadline ?? this.dateDeadline,
        dateEnd: dateEnd ?? this.dateEnd,
        description: description ?? this.description,
        name: name ?? this.name,
        priority: priority ?? this.priority,
        projectId: projectId ?? this.projectId,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
      );

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        active: json['active'],
        color: json['color'],
        dateDeadline: json['date_deadline'] != null
            ? DateTime.parse(json['date_deadline'])
            : null,
        dateEnd:
            json['date_end'] != null ? DateTime.parse(json['date_end']) : null,
        description: json['description'],
        name: json['name'],
        priority: json['priority'],
        projectId: json['project_id'],
        createDate: DateTime.parse(json['create_date']),
        writeDate: DateTime.parse(json['write_date']),
        isMarkedAsDeleted: json['is_marked_as_deleted'],
      );

  static const List<String> odooFields = [
    'id',
    'active',
    'color',
    'date_deadline',
    'date_end',
    'description',
    'name',
    'priority',
    'project_id',
  ];

  static const String odooModelName = 'project.task';
}

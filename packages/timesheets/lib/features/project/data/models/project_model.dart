// lib/features/projects/data/models/project_model.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:drift/drift.dart';
import 'package:timesheets/features/sync/sync.dart';

class ProjectModel extends SyncModel implements OdooModel, DriftModel {
  @override
  final int id;
  final bool active;
  final bool isFavorite;
  final int? color;
  final String name;
  final int taskCount;
  @override
  final DateTime createDate;
  @override
  final DateTime writeDate;
  @override
  final bool? isMarkedAsDeleted;

  ProjectModel({
    required this.id,
    required this.active,
    required this.isFavorite,
    this.color,
    required this.name,
    required this.taskCount,
    required this.createDate,
    required this.writeDate,
    this.isMarkedAsDeleted,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'active': active,
        'is_favorite': isFavorite,
        'color': color,
        'name': name,
        'task_count': taskCount,
        'create_date': createDate.toIso8601String(),
        'write_date': writeDate.toIso8601String(),
        'is_marked_as_deleted': isMarkedAsDeleted,
      };

  @override
  Map<String, dynamic> toOdooJson() => {
        'id': id,
        'active': active,
        'is_favorite': isFavorite,
        'color': color,
        'name': name,
        'task_count': taskCount,
      };

  @override
  UpdateCompanion toCompanion() => ProjectProjectsCompanion(
        id: Value(id),
        active: Value(active),
        isFavorite: Value(isFavorite),
        color: Value(color),
        name: Value(name),
        taskCount: Value(taskCount),
        createDate: Value(createDate),
        writeDate: Value(writeDate),
      );

  @override
  ProjectModel copyWith({
    int? id,
    bool? active,
    bool? isFavorite,
    int? color,
    String? name,
    int? taskCount,
    DateTime? createDate,
    DateTime? writeDate,
    bool? isMarkedAsDeleted,
  }) =>
      ProjectModel(
        id: id ?? this.id,
        active: active ?? this.active,
        isFavorite: isFavorite ?? this.isFavorite,
        color: color ?? this.color,
        name: name ?? this.name,
        taskCount: taskCount ?? this.taskCount,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
      );

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json['id'],
        active: json['active'],
        isFavorite: json['is_favorite'],
        color: json['color'],
        name: json['name'],
        taskCount: json['task_count'],
        createDate: DateTime.parse(json['create_date']),
        writeDate: DateTime.parse(json['write_date']),
        isMarkedAsDeleted: json['is_marked_as_deleted'],
      );

  static const List<String> odooFields = [
    'id',
    'active',
    'is_favorite',
    'color',
    'name',
    'task_count',
    'create_date',
    'write_date',
  ];

  static const String odooModelName = 'project.project';
}

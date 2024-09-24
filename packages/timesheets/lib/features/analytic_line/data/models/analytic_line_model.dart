import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:drift/drift.dart';
import 'package:timesheets/features/sync/sync.dart';

class AnalyticLineModel extends SyncModel implements OdooModel, DriftModel {
  @override
  final int id;
  final DateTime date;
  final String name;
  final int projectId;
  final int taskId;
  @override
  final DateTime createDate;
  @override
  final DateTime writeDate;

  @override
  final bool? isMarkedAsDeleted;

  AnalyticLineModel({
    required this.id,
    required this.date,
    required this.name,
    required this.projectId,
    required this.taskId,
    required this.createDate,
    required this.writeDate,
    this.isMarkedAsDeleted,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'name': name,
        'project_id': projectId,
        'task_id': taskId,
        'create_date': createDate.toIso8601String(),
        'write_date': writeDate.toIso8601String(),
        'is_marked_as_deleted': isMarkedAsDeleted,
      };

  @override
  Map<String, dynamic> toOdooJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'name': name,
        'project_id': projectId,
        'task_id': taskId,
      };

  @override
  UpdateCompanion toCompanion() => AnalyticLinesCompanion(
        id: Value(id),
        date: Value(date),
        name: Value(name),
        projectId: Value(projectId),
        taskId: Value(taskId),
      );

  @override
  AnalyticLineModel copyWith({
    int? id,
    int? accountId,
    DateTime? date,
    String? name,
    int? projectId,
    int? taskId,
    DateTime? createDate,
    DateTime? writeDate,
    bool? isMarkedAsDeleted,
  }) =>
      AnalyticLineModel(
        id: id ?? this.id,
        date: date ?? this.date,
        name: name ?? this.name,
        projectId: projectId ?? this.projectId,
        taskId: taskId ?? this.taskId,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
      );

  factory AnalyticLineModel.fromJson(Map<String, dynamic> json) =>
      AnalyticLineModel(
        id: json['id'],
        date: DateTime.parse(json['date']),
        name: json['name'],
        projectId: json['project_id'],
        taskId: json['task_id'],
        createDate: DateTime.parse(json['create_date']),
        writeDate: DateTime.parse(json['write_date']),
        isMarkedAsDeleted: json['is_marked_as_deleted'],
      );

  static const List<String> odooFields = [
    'id',
    'account_id',
    'date',
    'name',
    'project_id',
    'task_id',
    'create_date',
    'write_date',
  ];

  static const String odooModelName = 'account.analytic.line';
}

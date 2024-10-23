import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/utils/utils.dart';

class TimesheetModel extends SyncModel implements OdooModel, DriftModel {
  @override
  final int id;
  final DateTime date;
  final String name;
  final int projectId;
  final ProjectModel? project;
  final int taskId;
  final TaskModel? task;
  @override
  final DateTime createDate;
  @override
  final DateTime writeDate;

  final double? unitAmount;
  final TimerStatus? currentStatus;
  final DateTime? lastTicked;
  final DateTime? dateTime;
  final DateTime? dateTimeEnd;

  @override
  final bool? isMarkedAsDeleted;

  final bool isFavorite;

  final String? showTimeControl;

  TimesheetModel({
    required this.id,
    required this.date,
    required this.name,
    required this.projectId,
    required this.taskId,
    required this.createDate,
    required this.writeDate,
    this.isFavorite = false,
    this.isMarkedAsDeleted,
    this.project,
    this.task,
    this.unitAmount,
    this.currentStatus,
    this.lastTicked,
    this.dateTime,
    this.dateTimeEnd,
    this.showTimeControl,
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
        'project': project?.toJson(),
        'task': task?.toJson(),
        'unit_amount': unitAmount,
        'current_status': currentStatus?.index,
        'last_ticked': lastTicked?.toIso8601String(),
        'is_favorite': isFavorite,
        'date_time': dateTime?.toIso8601String(),
        'date_time_end': dateTimeEnd?.toIso8601String(),
        'show_time_control': showTimeControl,
      };

  @override
  Map<String, dynamic> toOdooJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'name': name,
        'project_id': projectId,
        'task_id': taskId,
        'unit_amount': unitAmount,
        'date_time': _formatDateTimeForOdoo(dateTime),
        'date_time_end': _formatDateTimeForOdoo(dateTimeEnd),
        'show_time_control': showTimeControl,
      };

  @override
  UpdateCompanion toCompanion() => AnalyticLinesCompanion(
        id: Value(id),
        date: Value(date),
        name: Value(name),
        projectId: Value(projectId),
        taskId: Value(taskId),
        unitAmount: Value(unitAmount),
        currentStatus: Value(currentStatus ?? TimerStatus.initial),
        lastTicked: Value(lastTicked),
        createDate: Value(createDate),
        writeDate: Value(writeDate),
        isFavorite: Value(isFavorite),
        startTime: Value(dateTime),
        endTime: Value(dateTimeEnd),
        showTimeControl: Value(showTimeControl),
      );

  @override
  TimesheetModel copyWith({
    int? id,
    int? accountId,
    DateTime? date,
    String? name,
    int? projectId,
    int? taskId,
    DateTime? createDate,
    DateTime? writeDate,
    bool? isMarkedAsDeleted,
    ProjectModel? project,
    TaskModel? task,
    double? unitAmount,
    TimerStatus? currentStatus,
    DateTime? lastTicked,
    bool? isFavorite,
    DateTime? dateTime,
    DateTime? dateTimeEnd,
    String? showTimeControl,
  }) =>
      TimesheetModel(
        id: id ?? this.id,
        date: date ?? this.date,
        name: name ?? this.name,
        projectId: projectId ?? this.projectId,
        taskId: taskId ?? this.taskId,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
        project: project ?? this.project,
        task: task ?? this.task,
        unitAmount: unitAmount ?? this.unitAmount,
        currentStatus: currentStatus ?? this.currentStatus,
        lastTicked: lastTicked ?? this.lastTicked,
        isFavorite: isFavorite ?? this.isFavorite,
        dateTime: dateTime ?? this.dateTime,
        dateTimeEnd: dateTimeEnd ?? this.dateTimeEnd,
        showTimeControl: showTimeControl ?? this.showTimeControl,
      );

  factory TimesheetModel.fromJson(Map<String, dynamic> json) => TimesheetModel(
        id: json['id'],
        date: DateTime.parse(json['date']),
        name: json['name'],
        projectId: extractRelationalId(json['project_id']) as int,
        taskId: extractRelationalId(json['task_id']) as int,
        createDate: DateTime.parse(json['create_date']),
        writeDate: DateTime.parse(json['write_date']),
        isMarkedAsDeleted: json['is_marked_as_deleted'],
        project: json['project'] != null
            ? ProjectModel.fromJson(json['project'])
            : null,
        task: json['task'] != null ? TaskModel.fromJson(json['task']) : null,
        unitAmount: json['unit_amount'],
        currentStatus: json['current_status'] != null
            ? TimerStatus.values[json['current_status']]
            : null,
        lastTicked: json['last_ticked'] != null
            ? DateTime.parse(json['last_ticked'])
            : null,
        isFavorite: json['is_favorite'] ?? false,
        dateTime: json['date_time'] != null && json['date_time'] is! bool
            ? DateTime.parse(json['date_time'])
            : null,
        dateTimeEnd:
            json['date_time_end'] != null && json['date_time_end'] is! bool
                ? DateTime.parse(json['date_time_end'])
                : null,
        showTimeControl: json['show_time_control'] != null &&
                json['show_time_control'] is! bool?
            ? json['show_time_control']
            : null,
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
    'unit_amount',
    'date_time',
    'date_time_end',
    'show_time_control',
  ];

  static const String odooModelName = 'account.analytic.line';
  static final _odooDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  String? _formatDateTimeForOdoo(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return _odooDateFormat.format(dateTime);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimesheetModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          name == other.name &&
          projectId == other.projectId &&
          taskId == other.taskId &&
          unitAmount == other.unitAmount &&
          currentStatus == other.currentStatus &&
          lastTicked == other.lastTicked &&
          isMarkedAsDeleted == other.isMarkedAsDeleted &&
          isFavorite == other.isFavorite &&
          dateTime == other.dateTime &&
          dateTimeEnd == other.dateTimeEnd;

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      name.hashCode ^
      projectId.hashCode ^
      taskId.hashCode ^
      unitAmount.hashCode ^
      currentStatus.hashCode ^
      lastTicked.hashCode ^
      isMarkedAsDeleted.hashCode ^
      isFavorite.hashCode ^
      dateTime.hashCode ^
      dateTimeEnd.hashCode;
}

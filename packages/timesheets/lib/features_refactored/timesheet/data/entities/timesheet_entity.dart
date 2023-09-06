import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/timesheet/data/database_tables/timesheet.dart';
import 'package:timesheets/features_refactored/app/data/entity.dart';

part 'timesheet_entity.g.dart';

@JsonSerializable()
class TimesheetEntity extends Entity {
  final int? id;
  @JsonKey(name: 'project_id')
  final int? projectId;
  @JsonKey(name: 'task_id')
  final int? taskId;

  /// indicates when timesheet was started
  @JsonKey(name: 'start_time')
  final DateTime? startTime;

  /// indicates when timesheet timer was last updated
  @JsonKey(name: 'end_time')
  final DateTime? endTime;

  @JsonKey(name: 'unit_amount')
  final double? unitAmount;

  /// [FOR LOCALLY USE ONLY] Indicates the current status of the timesheet
  @JsonKey(name: 'current_status')
  final TimesheetStatusEnum? currentStatus;

  /// [FOR LOCALLY USE ONLY] To keep track of the last time the timesheet was ticked
  /// for total spent time calculation
  @JsonKey(name: 'last_ticked')
  final DateTime? lastTicked;

  @JsonKey(name: 'is_favorite')
  final bool? isFavorite;

  final String? description;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  TimesheetEntity({
    this.id,
    this.projectId,
    this.taskId,
    this.startTime,
    this.endTime,
    this.unitAmount,
    this.currentStatus,
    this.lastTicked,
    this.isFavorite,
    this.createdAt,
    this.updatedAt,
    this.description,
  });

  factory TimesheetEntity.fromJson(Map<String, dynamic> json) =>
      _$TimesheetEntityFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$TimesheetEntityToJson(this);

  @override
  TimesheetEntity fromJSON(Map<String, dynamic> json) =>
      _$TimesheetEntityFromJson(json);
}

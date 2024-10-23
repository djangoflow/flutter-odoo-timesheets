// lib/features/analytic_lines/data/backends/analytic_line_drift_backend.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:drift/drift.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timer/timer.dart';

import '../models/analytic_line_model.dart';

class TimesheetDriftBackend
    extends DriftBackend<TimesheetModel, AnalyticLines, AnalyticLine> {
  TimesheetDriftBackend(AppDatabase database, String backendId)
      : super(database, database.analyticLines, backendId);

  @override
  UpdateCompanion<AnalyticLine> createCompanionWithBackendId(
      TimesheetModel item) {
    final companion = item.toCompanion() as AnalyticLinesCompanion;
    return companion.copyWith(backendId: Value(backendId))
        as UpdateCompanion<AnalyticLine>;
  }

  @override
  TimesheetModel fromJson(Map<String, dynamic> json) =>
      TimesheetModel.fromJson(json);

  @override
  TimesheetModel convertToModel(AnalyticLine driftModel) {
    logger.d('convertToModel: ${driftModel.unitAmount}');
    return TimesheetModel(
      id: driftModel.id,
      date: driftModel.date,
      name: driftModel.name,
      projectId: driftModel.projectId,
      taskId: driftModel.taskId,
      createDate: driftModel.createDate,
      writeDate: driftModel.writeDate,
      isMarkedAsDeleted: driftModel.isMarkedAsDeleted,
      currentStatus: driftModel.currentStatus,
      lastTicked: driftModel.lastTicked,
      unitAmount: driftModel.unitAmount,
      dateTime: driftModel.startTime,
      dateTimeEnd: driftModel.endTime,
      isFavorite: driftModel.isFavorite,
      showTimeControl: driftModel.showTimeControl,
    );
  }

  @override
  Future<List<TimesheetModel>> getAll({
    List<int>? ids,
    DateTime? since,
    int? projectId,
    int? taskId,
    int? limit,
    int? offset,
    bool? activeOnly,
    bool? favoriteOnly,
  }) async {
    // TODO need to make this query logic dry
    final query = database.select(table)
      ..where((tbl) => tbl.backendId.equals(backendId));

    if (ids != null && ids.isNotEmpty) {
      query.where((tbl) => tbl.id.isIn(ids));
    }
    if (since != null) {
      query.where((tbl) => tbl.writeDate.isBiggerThanValue(since));
    }
    if (projectId != null) {
      query.where((tbl) => tbl.projectId.equals(projectId));
    }
    if (taskId != null) {
      query.where((tbl) => tbl.taskId.equals(taskId));
    }

    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    if (activeOnly != null) {
      if (activeOnly) {
        query.where((tbl) => tbl.currentStatus.isIn([
              TimerStatus.running.index,
              TimerStatus.paused.index,
              TimerStatus.pausedByForce.index,
            ]));
      } else {
        query.where((tbl) => tbl.currentStatus.isNotIn([
              TimerStatus.running.index,
              TimerStatus.paused.index,
              TimerStatus.pausedByForce.index,
            ]));
      }
    }

    if (favoriteOnly != null) {
      query.where((tbl) => tbl.isFavorite.equals(favoriteOnly));
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.writeDate, mode: OrderingMode.desc)
    ]);

    final results = await query.get();
    return results.map((row) => convertToModel(row)).toList();
  }

  @override
  Future<TimesheetModel> update(TimesheetModel item) async {
    final companion = createCompanionWithBackendId(item);
    await database.into(table).insertOnConflictUpdate(
          companion,
        );
    logger.d(
        'Updating with companion: ${(companion as AnalyticLinesCompanion).unitAmount}');
    final updatedItem = await getById(item.id);
    if (updatedItem != null) {
      return updatedItem;
    } else {
      throw Exception('Failed to update item in Drift backend');
    }
  }
}

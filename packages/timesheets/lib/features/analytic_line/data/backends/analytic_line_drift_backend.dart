// lib/features/analytic_lines/data/backends/analytic_line_drift_backend.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:drift/drift.dart';
import 'package:timesheets/features/sync/sync.dart';

import '../models/analytic_line_model.dart';

class AnalyticLineDriftBackend
    extends DriftBackend<AnalyticLineModel, AnalyticLines, AnalyticLine> {
  AnalyticLineDriftBackend(AppDatabase database, String backendId)
      : super(database, database.analyticLines, backendId);

  @override
  UpdateCompanion<AnalyticLine> createCompanionWithBackendId(
      AnalyticLineModel item) {
    final companion = item.toCompanion() as AnalyticLinesCompanion;
    return companion.copyWith(backendId: Value(backendId));
  }

  @override
  AnalyticLineModel fromJson(Map<String, dynamic> json) =>
      AnalyticLineModel.fromJson(json);

  @override
  AnalyticLineModel convertToModel(AnalyticLine driftModel) =>
      AnalyticLineModel(
        id: driftModel.id,
        date: driftModel.date,
        name: driftModel.name,
        projectId: driftModel.projectId,
        taskId: driftModel.taskId,
        createDate: driftModel.createDate,
        writeDate: driftModel.writeDate,
        isMarkedAsDeleted: driftModel.isMarkedAsDeleted,
      );
}

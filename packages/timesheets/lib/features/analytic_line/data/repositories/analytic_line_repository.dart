// lib/features/analytic_lines/repositories/analytic_line_repository.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:timesheets/features/sync/sync.dart';

import '../models/analytic_line_model.dart';

class AnalyticLineRepository
    extends DriftOdooSyncRepository<AnalyticLineModel, AnalyticLines> {
  AnalyticLineRepository(
    super.primaryBackend,
    super.secondaryBackend,
    super.syncStrategy,
  );

  @override
  String get modelName => AnalyticLineModel.odooModelName;
}

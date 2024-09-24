// lib/features/analytic_lines/data/backends/analytic_line_odoo_backend.dart
import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import '../models/analytic_line_model.dart';

class AnalyticLineOdooBackend extends OdooBackend<AnalyticLineModel> {
  AnalyticLineOdooBackend(
    super.odooClient,
    super.connectionStateProvider,
  );

  @override
  AnalyticLineModel fromJson(Map<String, dynamic> json) =>
      AnalyticLineModel.fromJson(json);

  @override
  List<String> getFields() => AnalyticLineModel.odooFields;

  @override
  Map<String, dynamic> toOdooJson(AnalyticLineModel item) =>
      removeOdooReservedFields(item.toOdooJson());

  @override
  String get modelName => AnalyticLineModel.odooModelName;
}

import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetDriftOdooSyncStrategy
    extends DriftOdooSyncStrategy<TimesheetModel, AnalyticLines> {
  TimesheetDriftOdooSyncStrategy(
    super.syncRegistryRepository,
    super.driftBackendId,
    super.odooBackendId,
    super.idMappingRepository,
  );

  @override
  Future<TimesheetModel> resolveConflict(
      TimesheetModel sourceItem, TimesheetModel destinationItem) async {
    // Keep the local-only changes intact from overwriting the server changes
    final currentStatus =
        destinationItem.currentStatus ?? sourceItem.currentStatus;
    final lastTicked = destinationItem.lastTicked ?? sourceItem.lastTicked;
    final isFavorite = destinationItem.isFavorite || sourceItem.isFavorite;
    double? unitAmount =
        destinationItem.unitAmount != null && sourceItem.unitAmount != null
            ? destinationItem.unitAmount! > sourceItem.unitAmount!
                ? destinationItem.unitAmount
                : sourceItem.unitAmount
            : null;

    TimesheetModel result;

    result = await super.resolveConflict(sourceItem, destinationItem);
    unitAmount = unitAmount ??
        result.unitAmount ??
        sourceItem.unitAmount ??
        destinationItem.unitAmount;

    return result.copyWith(
      currentStatus: currentStatus,
      lastTicked: lastTicked,
      unitAmount: unitAmount,
      isFavorite: isFavorite,
    );
  }
}

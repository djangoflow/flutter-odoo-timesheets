import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/odoo.dart';

import '../models/odoo_timesheet.dart';

class OdooTimesheetRepository extends OdooRpcRepositoryBase {
  OdooTimesheetRepository(super.rpcClient);

  Future<List<OdooTimesheet>> getTimesheetList({
    required int backendId,
    required int projectId,
    required int taskId,
  }) async {
    final response = await odooCallMethod(
      backendId: backendId,
      method: OdooApiMethod.searchRead.name,
      odooModel: timesheetModel,
      parameters: [
        [
          [
            ['task_id', '=', taskId],
            ['project_id', '=', projectId],
          ],
        ],
        buildFilterableFields(_timesheetDefaultParams),
      ],
    );
    final timesheets = <OdooTimesheet>[];
    for (final timesheet in response) {
      timesheets.add(OdooTimesheet.fromJson(timesheet));
    }

    return timesheets;
  }

  Future<OdooTimesheet?> getTimesheetById({
    required int backendId,
    required int timesheetId,
  }) async {
    final response = await odooCallMethod(
      backendId: backendId,
      method: OdooApiMethod.searchRead.name,
      odooModel: timesheetModel,
      parameters: [
        [
          [
            ['id', '=', timesheetId],
          ],
        ],
        buildFilterableFields(_timesheetDefaultParams),
      ],
    );
    if (response['records'].isEmpty) {
      return null;
    }
    return OdooTimesheet.fromJson(response['records'][0]);
  }

  Future<List<OdooTimesheet>> getOdooTimesheetsByIds({
    required int backendId,
    required List<int> timesheetIds,
  }) async {
    final response = await odooCallMethod(
      backendId: backendId,
      method: OdooApiMethod.searchRead.name,
      odooModel: timesheetModel,
      parameters: [
        [
          [
            ['id', 'in', timesheetIds],
          ],
        ],
        buildFilterableFields(_timesheetDefaultParams),
      ],
    );
    final timesheets = <OdooTimesheet>[];

    for (final timesheet in response) {
      timesheets.add(OdooTimesheet.fromJson(timesheet));
    }

    return timesheets;
  }

  Future<OdooTimesheet?> update({
    required int backendId,
    required OdooTimesheetRequest timesheetRequest,
  }) async {
    if (timesheetRequest.id == null) {
      throw const OdooRepositoryException('Timesheet id is null');
    }
    await odooCallMethod(
      backendId: backendId,
      method: OdooApiMethod.write.name,
      odooModel: timesheetModel,
      parameters: [
        [
          timesheetRequest.id,
          timesheetRequest.toJson(),
        ],
      ],
    );

    return await getTimesheetById(
      backendId: backendId,
      timesheetId: timesheetRequest.id!,
    );
  }

  Future<int> create({
    required int backendId,
    required OdooTimesheetRequest timesheetRequest,
  }) async {
    final response = await odooCallMethod(
      backendId: backendId,
      method: OdooApiMethod.create.name,
      odooModel: timesheetModel,
      parameters: [
        [
          timesheetRequest.toJson(),
        ]
      ],
    );

    debugPrint(response.toString());

    return response;
  }

  Future<void> delete({
    required int backendId,
    required OdooTimesheetRequest timesheetRequest,
  }) async {
    await odooCallMethod(
      backendId: backendId,
      method: OdooApiMethod.unlink.name,
      odooModel: timesheetModel,
      parameters: [
        [
          timesheetRequest.id,
        ],
      ],
    );
  }

  static const _timesheetDefaultParams = [
    'name',
    'unit_amount',
    'project_id',
    'task_id',
    'user_id',
    'date_time',
    'date_time_end',
    'id',
  ];
}

import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/odoo.dart';

import '../models/odoo_timesheet.dart';

class OdooTimesheetRepository extends OdooRpcRepositoryBase {
  OdooTimesheetRepository(super.rpcClient);

  Future<List<OdooTimesheet>> getTimesheetList(
      [OdooTimesheetListFilter? filter]) async {
    final response = await odooCallMethod(
      method: OdooApiMethod.searchRead.name,
      odooModel: timesheetModel,
      parameters: [
        [
          if (filter != null)
            [
              ['user_id', '=', filter.userId],
              ['task_id', '=', filter.taskId],
              ['project_id', '=', filter.projectId],
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

  Future<OdooTimesheet?> getTimesheetById(int id) async {
    final response = await odooCallMethod(
      method: OdooApiMethod.searchRead.name,
      odooModel: timesheetModel,
      parameters: [
        [
          [
            ['id', '=', id],
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

  Future<List<OdooTimesheet>> getOdooTimesheetsByIds(List<int> ids) async {
    final response = await odooCallMethod(
      method: OdooApiMethod.searchRead.name,
      odooModel: timesheetModel,
      parameters: [
        [
          [
            ['id', 'in', ids],
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

  Future<OdooTimesheet?> update(OdooTimesheetRequest timesheetRequest) async {
    if (timesheetRequest.id == null) {
      throw const OdooRepositoryException('Timesheet id is null');
    }
    await odooCallMethod(
      method: OdooApiMethod.write.name,
      odooModel: timesheetModel,
      parameters: [
        [
          timesheetRequest.id,
          timesheetRequest.toJson(),
        ],
      ],
    );

    return await getTimesheetById(timesheetRequest.id!);
  }

  Future<int> create(OdooTimesheetRequest timesheetRequest) async {
    final response = await odooCallMethod(
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

  Future<void> delete(OdooTimesheetRequest timesheetRequest) async {
    await odooCallMethod(
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

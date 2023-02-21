import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_method.dart';

///Repository to fetch projects data
class ActivityRepository extends OdooRpcRepositoryBase {
  Future addTimesheetEntry({
    required Map<String, dynamic> data,
  }) async {
    await rpcGetObject(
      odooModel: timesheetEntryModel,
      method: OdooApiMethod.create.name,
      parameters: [
        [
          data,
        ]
      ],
    );
  }
}

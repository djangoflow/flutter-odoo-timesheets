import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_method.dart';

///Repository to fetch projects data
class ActivityRepository extends OdooRpcRepositoryBase {
  ActivityRepository(super.rpcClient);

  Future addTimesheetEntry({
    required Map<String, dynamic> data,
  }) async {
    await odooCallMethod(
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

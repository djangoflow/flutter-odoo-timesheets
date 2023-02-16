import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_method.dart';

///Repository to fetch projects data
class ActivityRepository extends OdooRepositoryBase {
  Future addTimesheetEntry({
    required int id,
    required String password,
    required Map<String, dynamic> data,
  }) async {
    await getObject(
      id,
      password,
      timesheetEntryMethod,
      OdooApiMethod.create.name,
      [
        [
          data,
        ]
      ],
    );
  }
}

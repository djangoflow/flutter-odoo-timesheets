import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/data/models/odoo_project.dart';

import '../odoo_api_method.dart';
import 'odoo_repository_base.dart';

///Repository to fetch projects data using [OdooRepository]
class OdooProjectRepository extends OdooRpcRepositoryBase {
  OdooProjectRepository(super.rpcClient);

  Future<List<OdooProject>> getProjects(
      {required int backendId, int? limit, int? offset, String? search}) async {
    Map<String, dynamic> optionalParams = buildFilterableFields([name]);
    if (limit != null && offset != null) {
      optionalParams.addAll({
        offsetKey: offset,
        limitKey: limit,
      });
    }
    final searchParameters = [];
    if (search != null) {
      searchParameters.add(
        [
          name,
          caseInsensitiveComparison,
          '$search%',
        ],
      );
    }

    var response = await odooCallMethod(
      backendId: backendId,
      odooModel: projectModel,
      method: OdooApiMethod.searchRead.name,
      parameters: [
        [searchParameters],
        optionalParams,
      ],
    );

    final projects = <OdooProject>[];
    for (final project in response) {
      projects.add(OdooProject.fromJson(project));
    }
    return projects;
  }
}

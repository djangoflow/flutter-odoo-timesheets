import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/blocs/odoo_project_list_cubit/odoo_project_list_cubit.dart';
import 'package:timesheets/features/odoo/data/models/odoo_project.dart';

import '../odoo_api_method.dart';
import 'odoo_repository_base.dart';

///Repository to fetch projects data using [OdooRepository]
class OdooProjectRepository extends OdooRpcRepositoryBase {
  OdooProjectRepository(super.rpcClient);

  Future<List<OdooProject>> getProjects([OdooProjectListFilter? filter]) async {
    Map<String, dynamic> optionalParams = buildFilterableFields([name]);
    if (filter != null) {
      optionalParams.addAll({
        offset: filter.offset,
        limit: filter.limit,
      });
    }
    final searchParameters = [];
    if (filter != null && filter.search != null) {
      searchParameters.add(
        [
          name,
          caseInsensitiveComparison,
          '${filter.search}%',
        ],
      );
    }

    var response = await odooCallMethod(
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

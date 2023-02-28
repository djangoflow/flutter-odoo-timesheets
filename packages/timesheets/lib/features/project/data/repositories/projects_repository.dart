import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_method.dart';
import 'package:timesheets/features/project/blocs/project_list_bloc/project_list_filter.dart';
import 'package:timesheets/features/project/project.dart';

///Repository to fetch projects data using [OdooRepository]
class ProjectRepository extends OdooRpcRepositoryBase {
  ProjectRepository(super.rpcClient);

  Future<List<Project>> getProjects([ProjectListFilter? filter]) async {
    var response = await odooCallMethod(
      odooModel: projectModel,
      method: OdooApiMethod.searchRead.name,
      parameters: [
        [],
        buildFilterableFields(['name'])
          ..addAll({
            'limit': filter?.limit,
            'offset': filter?.offset,
          }),
      ],
    );

    final projects = <Project>[];
    for (final project in response) {
      projects.add(Project.fromJson(project));
    }
    return projects;
  }
}
